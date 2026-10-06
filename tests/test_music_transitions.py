"""Run the actual Processing sketch with headless drawing and audio test doubles."""

from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
SKETCH = ROOT / "Galaxy_Game" / "Galaxy_Game.pde"


def java_source(sketch):
    # Processing adds float suffixes to decimal literals before compiling Java.
    tokens = re.compile(
        r'//[^\n]*|/\*[\s\S]*?\*/|"(?:\\.|[^"\\])*"|'
        r"'(?:\\.|[^'\\])*'|(?<![\w.])(?:\d+\.\d*|\.\d+)(?![\w.])"
    )
    sketch = tokens.sub(
        lambda match: match[0] + "f"
        if re.fullmatch(r"(?:\d+\.\d*|\.\d+)", match[0])
        else match[0],
        sketch,
    )
    sketch = sketch.replace("import processing.sound.*;", "")
    return "import java.util.*;\nclass GalaxySketch extends DrawingStub {\n" + sketch + "\n}\n"


STUBS = r"""
class PVector {
  float x, y;
  PVector(float x, float y) { this.x = x; this.y = y; }
}
class PImage {
  int width = 1920, height = 1080;
  void resize(int width, int height) { this.width = width; this.height = height; }
}
class AudioSample {
  int voices, starts;
  boolean looping;
  void play() { voices++; starts++; looping = false; }
  void loop() { voices++; starts++; looping = true; }
  void stop() { voices = 0; }
}
class SoundFile extends AudioSample {
  SoundFile(Object sketch, String path) {}
}
class DrawingStub {
  int width = 1920, height = 1080, frameCount;
  int mouseX, mouseY, keyCode;
  char key;
  boolean mousePressed;
  final int CENTER = 3, CORNER = 0, UP = 38, DOWN = 40, LEFT = 37, RIGHT = 39;
  void fullScreen() {}
  void frameRate(int rate) {}
  PImage loadImage(String path) { return new PImage(); }
  void image(PImage image, double... args) {}
  void copy(PImage image, int... args) {}
  void imageMode(int mode) {}
  void rectMode(int mode) {}
  void fill(double... args) {}
  void stroke(double... args) {}
  void strokeWeight(double weight) {}
  void noStroke() {}
  void rect(double... args) {}
  void textSize(double size) {}
  void text(Object text, double... args) {}
  void background(int color) {}
  void pushMatrix() {}
  void popMatrix() {}
  void translate(double... args) {}
  void rotate(double angle) {}
  void tint(double... args) {}
  void exit() {}
  int color(int... values) { return Arrays.hashCode(values); }
  int max(int a, int b) { return Math.max(a, b); }
  float random(double low, double high) { return (float)((low + high) / 2); }
  float radians(double degrees) { return (float)Math.toRadians(degrees); }
  float lerp(double start, double stop, double amount) { return (float)(start + (stop-start)*amount); }
  float dist(double x1, double y1, double x2, double y2) { return (float)Math.hypot(x1-x2, y1-y2); }
  float map(double value, double low, double high, double outLow, double outHigh) {
    return (float)(outLow + (value-low) * (outHigh-outLow) / (high-low));
  }
}
"""


HARNESS = r"""
public class MusicRegression {
  static void check(boolean condition, String message) {
    if (!condition) throw new AssertionError(message);
  }
  static GalaxySketch newGame() {
    GalaxySketch game = new GalaxySketch();
    game.setup();
    return game;
  }
  static AudioSample[] tracks(GalaxySketch game) {
    return new AudioSample[]{game.menuSound, game.shopSound, game.song, game.bossSound, game.finalBoss, game.dead};
  }
  static void expectMusic(GalaxySketch game, AudioSample expected) {
    int total = 0;
    for (AudioSample track : tracks(game)) {
      total += track.voices;
      check(track.voices == (track == expected ? 1 : 0), "wrong track or overlapping playback");
    }
    check(total == (expected == null ? 0 : 1), "more than one music voice");
  }
  static void frames(GalaxySketch game, int count) {
    for (int i = 0; i < count; i++) { game.frameCount++; game.draw(); }
  }
  static void startGame(GalaxySketch game) {
    game.menu = false;
    game.game = true;
    game.rocks.clear();
  }
  static void die(GalaxySketch game) {
    game.healthPoints = 0;
    frames(game, 1);
    expectMusic(game, game.dead);
  }
  public static void main(String[] args) {
    GalaxySketch game = newGame();
    switch (args[0]) {
      case "steady-menu":
        frames(game, 600);
        expectMusic(game, game.menuSound);
        check(game.menuSound.starts == 1, "menu restarts every frame");
        check(game.menuSound.looping, "background music must loop without new play calls");
        break;
      case "menu-shop-options":
        frames(game, 1);
        game.mousePressed = true;
        game.mouseX = 900;
        game.mouseY = 760;
        frames(game, 1);
        expectMusic(game, game.shopSound);
        game.mouseX = 20;
        game.mouseY = 20;
        frames(game, 1);
        expectMusic(game, game.menuSound);
        game.mouseX = 900;
        game.mouseY = 930;
        frames(game, 1);
        expectMusic(game, game.menuSound);
        game.mousePressed = false;
        frames(game, 120);
        check(game.menuSound.starts == 2, "options should keep menu music playing");
        game.options = false;
        game.menu = true;
        game.mousePressed = true;
        game.mouseX = 900;
        game.mouseY = 530;
        frames(game, 1);
        expectMusic(game, game.song);
        break;
      case "boss-progression":
        startGame(game);
        frames(game, 1);
        expectMusic(game, game.song);
        game.score = 50;
        frames(game, 120);
        expectMusic(game, game.bossSound);
        check(game.bossSound.starts == 1, "boss music restarts every frame");
        game.bossHealth = 0;
        frames(game, 1);
        check(game.score == 60, "first boss should advance progression");
        expectMusic(game, game.song);
        game.rocks.clear();
        game.score = 100;
        frames(game, 1);
        expectMusic(game, game.bossSound);
        game.bossHealth1 = 0;
        frames(game, 1);
        check(game.score == 110, "second boss should advance progression");
        expectMusic(game, game.song);
        game.rocks.clear();
        game.score = 150;
        frames(game, 120);
        expectMusic(game, game.finalBoss);
        game.bossHealth3 = 0;
        frames(game, 120);
        expectMusic(game, null);
        break;
      case "death-retry":
      case "death-menu":
        startGame(game);
        frames(game, 1);
        for (int score : new int[]{50, 60, 100, 110, 150}) {
          game.score = score;
          game.rocks.clear();
          frames(game, 1);
          game.bossHealth = 120;
          game.bossHealth1 = 230;
          game.bossHealth3 = 340;
          die(game);
          int starts = game.dead.starts;
          frames(game, 120);
          expectMusic(game, game.dead);
          check(game.dead.starts == starts, "death music restarts every frame");
          game.mousePressed = true;
          game.mouseX = 850;
          game.mouseY = args[0].equals("death-retry") ? 530 : 760;
          frames(game, 1);
          expectMusic(game, args[0].equals("death-retry") ? game.song : game.menuSound);
          check(game.bossHealth == 500 && game.bossHealth1 == 1000 && game.bossHealth3 == 5000,
                "retry must restore all boss health");
          game.mousePressed = false;
          startGame(game);
          frames(game, 1);
        }
        break;
      case "final-boss-retry-overlap":
        startGame(game);
        frames(game, 1);
        game.score = 150;
        frames(game, 1);
        expectMusic(game, game.finalBoss);
        game.healthPoints = 0;
        frames(game, 1);
        game.mousePressed = true;
        game.mouseX = 850;
        game.mouseY = 530;
        frames(game, 1);
        game.mousePressed = false;
        game.rocks.clear();
        frames(game, 1);
        check(game.finalBoss.voices == 0, "final-boss music overlaps the next run");
        expectMusic(game, game.song);
        break;
      case "boss-projectiles":
        startGame(game);
        for (int score : new int[]{50, 100}) {
          game.score = score;
          game.bossShots.add(game.new BossShot(20, 400, true));
          if (score == 50) game.bossHealth = 0; else game.bossHealth1 = 0;
          frames(game, 1);
          check(game.bossShots.isEmpty(), "defeated boss leaves projectiles for the next fight");
          check(game.bossShotCooldownCounter == 0, "new boss should not inherit a cooldown");
          expectMusic(game, game.song);
        }
        break;
      default:
        throw new IllegalArgumentException(args[0]);
    }
    System.out.println("PASS " + args[0]);
  }
}
"""


class MusicTransitionsTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not shutil.which("java"):
            raise RuntimeError("These tests require a Java JDK and Python 3.")
        cls.workspace = tempfile.TemporaryDirectory()
        cls.addClassCleanup(cls.workspace.cleanup)
        directory = Path(cls.workspace.name)
        source = directory / "MusicRegression.java"
        source.write_text(java_source(SKETCH.read_text()) + STUBS + HARNESS)
        javac = [shutil.which("javac")] if shutil.which("javac") else ["java", "com.sun.tools.javac.Main"]
        result = subprocess.run(javac + ["-d", str(directory), str(source)], text=True, capture_output=True)
        if result.returncode:
            raise RuntimeError("Sketch compilation failed:\n" + result.stderr)
        cls.classpath = str(directory)

    def run_scenario(self, scenario):
        result = subprocess.run(
            ["java", "-cp", self.classpath, "MusicRegression", scenario],
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_music_does_not_restart_each_frame(self):
        self.run_scenario("steady-menu")

    def test_menu_shop_options_and_start(self):
        self.run_scenario("menu-shop-options")

    def test_all_bosses_and_victory(self):
        self.run_scenario("boss-progression")

    def test_death_and_direct_retry_from_each_stage(self):
        self.run_scenario("death-retry")

    def test_death_and_return_to_menu_from_each_stage(self):
        self.run_scenario("death-menu")

    def test_final_boss_music_does_not_overlap_the_next_run(self):
        self.run_scenario("final-boss-retry-overlap")

    def test_defeated_boss_projectiles_are_cleared(self):
        self.run_scenario("boss-projectiles")


if __name__ == "__main__":
    unittest.main()
