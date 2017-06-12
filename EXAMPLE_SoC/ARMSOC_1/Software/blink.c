

void init(void)
{
	static unsigned int *p;
	p = (unsigned int *)0x50000000;
	while(1) {
	    delay();
	   *p=0x55;
	    delay();
	   *p=0xaa;
	}
	//return 1;
		
}

void delay(void) {
	static int i;
	for (i=0xFFFF;i>0;i--);
	
}
/*
int _exit(void) {
	return 1;
}
*/