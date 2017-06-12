


// demo.c
// jardel@ufc.br


#define DUR 0x1FFFE

// Define Morse code for letters
char codes[26][6] = {
 ".-",   // A
 "-...", // B
 "-.-.", // C
 "-..",  // D
 ".",    // E
 "..-.", // F
 "--.",  // G
 "....", // H
 "..",   // I
 ".---", // J
 "-.-",  // K
 ".-..", // L
 "--",   // M
 "-.",   // N
 "---",  // O
 ".--.", // P
 "--.-", // Q
 ".-.",  // R
 "...",  // S
 "-",    // T
 "..-",  // U
 "...-", // V
 ".--",  // W
 "-..-", // X
 "-.--", // Y
 "--.."  // Z 
};
char message[]="JOHN";

void playChar(char c) {
	int i=0;
	i=0;
	while (codes[c-'A'][i]) {
	 // digitalWrite(13, 1);
	  if (codes[c-'A'][i] == '.') {
				 digitalWrite(13, 1);

		delayLoop(DUR);   // dot
	 
	  }	
	  else {  
		digitalWrite(13, 0xFF);

	  delayLoop(3*DUR); // dash
	 	  
	  }
	  digitalWrite(13, 0);
	  delayLoop(DUR); // pause between elements
		i++;
	}
	 digitalWrite(13, 0x55);
	
	delayLoop(DUR*2); // extra pause between characters
}
		
void playStr(char msg[]) {
	 int i=0;
	 i=0;
	 while(msg[i]) 
		 playChar(msg[i++]);
}

void main(void) {
	unsigned int *p;
	
	while (1) {
	  playStr(message);
	  delayLoop((int)DUR*4); // extra pause between words
	 }
}


void digitalWrite(int pin, int state){
	unsigned int *p;
	p = (unsigned int *)0x50000000;
	*p = (int) state;
}


void delayLoop(int x) {
	static int i;
	for (i=x;i>0;i--);
	
}

