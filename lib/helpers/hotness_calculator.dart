import 'dart:math';

class Hotness {
  final int upvotes;
  final int time;
  final int downvotes;
  final int views;
  final int comments;
  Hotness(this.time,this.downvotes,this.upvotes,this.views,this.comments);
  double calculate() {
    int ans = comments + 4*upvotes - 2*downvotes + views;
    var value = log(time%100000)/log(10);
    print(ans);
    print(value);
    return ans+value;
  }
}