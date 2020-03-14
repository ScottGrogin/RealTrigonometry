/* 

  The following is an improvement of my pervious  metric trig sketch that can be seen here 
  https://github.com/ScottGrogin/RealTrigonometry/blob/master/metricTrig/metricTrig.pde
  
  After working out more of the math behind what I was doing I realized that a hash map was not needed and we could instead use the sin and cos of the angle as they will return 
  values -1 to 1 as they are needed for calculations. 
  
  The purpose of this code is to create sin and cos esque tracing functions for circles in
 any metric space. It is made so that one can, for example, trace out the diamond like circle 
 in the taxi cab metric and switch over to some other metric without having to create a custom
 tracing function. I will refer to the generalized tracing functions as sin and cos for simplicity.
 
 How it works:
 Sin = Opposite / Hypotenuse
 Cos = Adjacent / Hypotenuse
 
 The hypotneuse represents the radius of a circle and it can be calculated with the x and y components of a point / vector / right triangle side lengths,
 in euclidean space this is done with sqrt( x^2 + y^2 ); for other metric spaces you would just substute this with 
 your metric operator (e.g. Taxi cab hypotenuse = abs(x) + abs(y).
 
 This means the sin of an angle should be the y value of a point over the result of the metric operator (y/metric op result),
 and the cos would do the same , but with the x value (x/ metric op result)
 (e.g. Taxicab sin and cos for the pont (1,1): sin = 1/(abs(1)+abs(1)),  cos = 1/(abs(1)+abs(1)) -> sin = 1/2, cos = 1/2)
 
 
 
 */
float theta;
public void setup() {
  size(800, 800);
  background(255);
  strokeWeight(4);
  theta = 0;
}

public float mSin(float angl) {

  return sin(angl)/(metricOp(cos(angl), sin(angl))) ;
}

public float mCos(float angl) {
  return cos(angl)/(metricOp(cos(angl), sin(angl))) ;
}



private float metricOp(float x, float y) {
  
  //Uncomment different returns to see other shapes
 
  //Diamond
  return abs(x) + abs(y);
 
  
  //Rounded Square
  //float p=10.5;
  //return pow(pow(abs(x),p)+pow(abs(y),p),1/p);
  
}
public void draw() {
  stroke(0,255,0);
  
  translate(width/2, height/2);
  stroke(0);
  point(mCos(radians(theta))*100, mSin(radians(theta))*100);
  theta +=0.5;
}
