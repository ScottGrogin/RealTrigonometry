/* //<>//
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
 
 Now we need a way to associate an angle with a sin and cos value. To do this we can create a loop that will generate points
 along a square and take the inverse tangent to get the angle associated with the points and store it in a table (or hash map in
 this case). Later when we plug in that angle to a function we can get the points associated with it and do sin and cos calculations
 based on our chosen metric.
 
 (-1,1)                                           (1,1)
 MsooooooooooooooooooooooddoooooooooooooooooooooosM
 M`                    :dssd:                    `M
 M`                  :ds.  .sd:                  `M
 M`                :ds.      .sd:                `M
 M`              :ds.          .sd:              `M
 M`            :ds.              .sd:            `M
 M`          :ds.                  .sd:          `M
 M`        :ds.                      .sd:        `M
 M`      :ds.                          .sd:      `M
 M`    :ds.                              .sd:    `M
 M`  :ds.                                  .sd:  `M
 M`:ds.                                      .sd:`M
 MyN-                                          -NyM
 M`:ds.                                      .sd:`M
 M`  :ds.                                  .sd:  `M
 M`    :ds.                              .sd:    `M
 M`      :ds.                          .sd:      `M
 M`        :ds.                      .sd:        `M
 M`          :ds.                  .sd:          `M
 M`            :ds.              .sd:            `M
 M`              :ds.          .sd:              `M
 M`                :ds.      .sd:                `M
 M`                  :ds.  .sd:                  `M
 M`                    :dssd:                    `M
 MsooooooooooooooooooooooddoooooooooooooooooooooosM
 (-1,-1)                                          (1,-1)
 
 */
import java.util.HashMap;
import java.util.*;
int samples = 50;
float squareSize=1.0;
int scale=100;

HashMap<Float, PVector> angleTable = new HashMap<Float, PVector>();
Float[] farr;
PrintWriter output;


void setup() {

  size(600, 600);
  stroke(255, 255, 0);
  strokeWeight(8);
  background(0);
  frameRate(120);

  /*
    This is where go along the sides of a square to geneate points and calculate angles based
   on those points and store those in a hash map
   */
  for (float i = -samples; i <= samples; i+=.1) {
    angleTable.put(degrees(atan2((float)-squareSize, (float)i/ (float)samples)), new PVector((float)i/ (float)samples, (float)-squareSize));
    angleTable.put(degrees(atan2((float)squareSize, (float)i/ (float)samples)), new PVector((float)i/ (float)samples, (float)squareSize));
    angleTable.put(degrees(atan2((float)i/ (float)samples, (float)-squareSize)), new PVector((float)-squareSize, (float)i/ (float)samples));
    angleTable.put(degrees(atan2((float)i/ (float)samples, (float)squareSize)), new PVector((float)squareSize, (float)i/ (float)samples));
  }

  farr = new Float[angleTable.keySet().size()];
  angleTable.keySet().toArray(farr);

  Arrays.sort(farr);
}

//Here are the actual sin and cos functions

float mSin(float angle) {
  angle = (angle % 360) -180;
  angle = getClosestValue(angle);
  if (angleTable.containsKey(Float.valueOf(angle))) {
    float x = angleTable.get(Float.valueOf(angle)).x;
    float y = angleTable.get(Float.valueOf(angle)).y;
    //sin = y/metric op
    return(y/(hyp(x, y)));
  } 
  return 0;
}
float mCos(float angle) {
  angle = (angle % 360) -180;
  angle = getClosestValue(angle);
  if (angleTable.containsKey(Float.valueOf(angle))) {
    float x = angleTable.get(Float.valueOf(angle)).x;
    float y = angleTable.get(Float.valueOf(angle)).y;
    // cos = x/ metric op
    return(x/hyp(x, y));
  } 
  return 0;
}

//This function is used to define a hypotenuse.
//Change it to change the shape that is traced out.

float hyp(float x, float y) {
  //return(max(abs(x), abs(y)));//square circle
  
  //return((abs(x)+abs(y)));//diamond circle
  
  //return(sqrt(x*x+y*y)); // circular circle
  
  //if (abs(y)>abs(x)) {//octo circle
  //  return(1.41*abs(x)+0.9412*abs(y));//octo circle
  //} return (1.41*abs(y)+0.9412*abs(x));//octo circle
  
  if (abs(y)>abs(x)) {//shuriken circle
    return(2.41*abs(x)+0.9412*abs(y));//shuriken  circle
  } return (2.41*abs(y)+0.9412*abs(x));//shuriken  circle
  
  
  
   
  
}

/*
  If the angle you want is not in the map, this function will
 get an angle close to what you want.
 */
private float getClosestValue(float value) {
  Float[] searchArr=farr.clone();

  int index = 0, preInd =0;
  Float lookingFor = value;
  boolean found = false;


  while (!found) {
    preInd = index;
    index = (int)(searchArr.length/2);
    if (preInd == index) {
      found = true;
      if (searchArr.length==0 && index == 0) {
        return(farr[index]);
      }
      return(searchArr[index]);
    }
    if (searchArr[index] == lookingFor) {
      found = true;
      return(searchArr[index]);
    } else if (lookingFor < searchArr[index]) {
      searchArr = Arrays.copyOfRange(searchArr, 0, index);
    } else if (lookingFor > searchArr[index]) {
      searchArr = Arrays.copyOfRange(searchArr, index, searchArr.length);
    }
  } 
  return 0.0;
}


float i = 0;
void draw() {
  fill(0, 5);
  noStroke();
  rect(0,0,width,height);
  stroke(255, 255, 0);
  translate(width/2, height/2);

  point(mCos(i)*scale, mSin(i)*scale);
  i+=0.8;
  saveFrame();
}
