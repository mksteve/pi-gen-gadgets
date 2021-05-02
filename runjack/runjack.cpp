#include <string>
#include <stdlib.h>
int main( int argc, char ** argv )
{
	std::string cmd = "/bin/bash /home/pi/runjack.sh";
	for( auto i = 1; i < argc; i++ ){
		std::string s = argv[i];
		cmd += " ";
		cmd += s;
	}
  	printf( "%s\n", cmd.c_str() );
	fflush(stdout);
	system(cmd.c_str() ); 
}
