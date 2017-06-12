#include <stdio.h>
#include <string.h>

#define RWINDOWS

#ifdef RWINDOWS
    #define MAIS1 1
#else
    #define MAIS1 0
#endif


void main(int argc, char**argv) {

	char buf[100], *p,s1[10],s2[10],s3[10],s4[10],s5[10],s6[10],s7[10],s8[10],s9[10],s10[10],s11[10],s12[10],s13[10],s14[10],s15[10],s16[10];
	FILE *fin, *fout;
	int i,n;
	char temp[100];
	i=0;
	if(argc!=4)
	{
		printf("\nUsage: v2sv <filein> <sv out filename> <firsindex> \n\n");
		return;
	}

	fin=fopen(argv[1],"r") ;
	if (fin==NULL) {
		printf("Erro ao abrir arquivo hex de entrada");
		return;
	}
	strcpy(temp,argv[2]);
	strcat(temp, ".sv");

	fout=fopen(temp,"w") ;
	if (fout==NULL) {
		printf("Erro ao truncar/criar arquivo array de saída");
		return;
	}

	


	//i=atoi(argv[3]);

	//fprintf(fout,"  reg [31:0] memory[0:%s];\n", argv[3]); 
	fprintf(fout,"  initial\n");
	fprintf(fout,"  begin\n");
	p=fgets(buf, 100,fin);
	sscanf(buf, "@%x", &i);
	i/=4;

	// i=0;
	//i=atoi(temp);

	while((!feof(fin))) {

		p=fgets(buf, 100,fin);
		if (buf[0]=='@')
			break;
		n=strlen(buf);
        n+=MAIS1;
        //printf("i=%d n=%d\n",i,n);

//50 38 26 14
			sscanf(buf, "%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s", s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16);


			if(n>=14) {

			fprintf(fout,"memory[%d]='h%s%s%s%s;\n", i, s4,s3,s2,s1);
			i++;
			}
			if(n>=26) {
			fprintf(fout,"memory[%d]='h%s%s%s%s;\n", i, s8,s7,s6,s5);
			i++;
			}

			if(n>=38) {

			fprintf(fout,"memory[%d]='h%s%s%s%s;\n", i, s12,s11,s10,s9);
			i++;
			}
			if(n==50)
				fprintf(fout,"memory[%d]='h%s%s%s%s;\n", i, s16,s15,s14,s13);
			//else
			//	break;
		i++;
	}
	
	
		//p=fgets(buf, 100,fin);
	sscanf(buf, "@%x", &i);
	printf ("\n buf %s \n", buf);
	i/=4;
	// i=0;
	//i=atoi(temp);

	while((!feof(fin))) {

		p=fgets(buf, 100,fin);
		n=strlen(buf);
        n+=MAIS1;
        //printf("i=%d n=%d\n",i,n);

//50 38 26 14
			sscanf(buf, "%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s", s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16);


			if(n>=14) {

			fprintf(fout,"memory[%d]='h%s%s%s%s;\n", i, s4,s3,s2,s1);
			i++;
			}
			if(n>=26) {
			fprintf(fout,"memory[%d]='h%s%s%s%s;\n", i, s8,s7,s6,s5);
			i++;
			}

			if(n>=38) {

			fprintf(fout,"memory[%d]='h%s%s%s%s;\n", i, s12,s11,s10,s9);
			i++;
			}
			if(n==50)
				fprintf(fout,"memory[%d]='h%s%s%s%s;\n", i, s16,s15,s14,s13);
			else
				break;
		i++;
	}
	fclose(fin);
	fclose(fout);
}
