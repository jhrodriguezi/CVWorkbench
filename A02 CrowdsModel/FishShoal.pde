class FishShoal {
  List<Fish> fish;
  PImage fimg;
  
  FishShoal(PImage fimg) {
    fish = new ArrayList<>();
    this.fimg = fimg;
  }
  
  void run(List<Obstacle> obstacles) {
    for(Fish f : fish) {
      f.run(fish, obstacles);
    }
  }
  
  void addFish(Fish f) {
    f.setImage(fimg);
    fish.add(f);
  }
}
