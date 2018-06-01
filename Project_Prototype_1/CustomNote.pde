
/**
Custom note class for Minim AudioOutput
created by Alexander Keidel, 22397868 on 10.12.2016
last edited 10.12.2016
see http://code.compartmental.net/minim/audiooutput_method_playnote.html
*/

class CustomNote {
  public float startTime, duration;
  public String pitchName;
  public CustomNote(float startTime, float duration, String pitchName){
    this.startTime = startTime;
    this.duration = duration;
    this.pitchName = pitchName;
  }
}