#include <string>

std::string get_line_of_code(const char* code) //return the line of code
{
	std::string ret = code;	
	int i;	
	for(i = 0;i<ret.length();i++)
	{
		if(ret[i]=='\n'||ret[i]=='{') break;
	}	
	return ret.substr(0,i);
} 

std::string cut_commentary(const std::string line) //cut commentary at the end of line
{
	int i = 0;
	for(i = 0;i<line.length()-1;i++)
	{
		if(line[i]=='/' && line[i+1]=='/') return line.substr(0,i);
		if(line[i]=='/' && line[i+1]=='*') return line.substr(0,i);
	}
	return line;

}

bool is_derived(const std::string line) // return true if the struct or class is derived
{
	int i = 0;
	for(i = 0;i<line.length()-1;i++)
	{
		if(line[i]==':')
		{
			if(line[i+1]!=':') return true;
			else i+=1;
		}
	}
	return false;
}

std::string get_super_class(const std::string line) // get the super class of this declarations
{
	int i = 0;
	for(i = 0;i<line.length()-1;i++)
	{
		if(line[i]==':')
		{
			if(line[i+1]!=':') break;
			else i+=1;
		}
	}
	return line.substr(i+1);
}

std::string get_next_base(const std::string line) // get the super class of this declarations
{
	int i = 0;
	int brackets = 0;
	for(i = 0;i<line.length()-1;i++)
	{
		if(line[i]=='<') brackets+=1;
		if(line[i]=='>') brackets-=1;
		if(line[i]==',' && brackets == 0) break;
	}
	return line.substr(i+1);
}  

std::string get_first_base(const std::string line) // get the super class of this declarations
{
	int i = 0;
	int brackets = 0;
	for(i = 0;i<line.length()-1;i++)
	{
		if(line[i]=='<') brackets+=1;
		if(line[i]=='>') brackets-=1;
		if(line[i]==',' && brackets == 0) break;
	}
	return line.substr(0,i);
}  


std::string clean_spaces(const std::string line)
{
	int i;
	std::string new_line = "";
	for(i = 0;i<line.length();i++)
	{
		if(!isspace(line[i])) new_line+=line[i];
	}
	//std::cout<<new_line;
	return new_line;
}

bool is_state(const std::string line)
{
	int pos = line.find("::");
	if(pos==10)
	{
		if(line.compare(0,24,"statechart::simple_state")==0)
		{
			return true;	
		}
		else
		{
			std::string str = line.substr(pos+2);
			if(str.compare(0,12,"simple_state")==0)return true;
		}
	}
	else
	{
		std::string str = line.substr(pos+2);
		//std::cout<<str;
		if(str.compare(0,12,"simple_state")==0)return true;
	}
	return false;
}
// Transitions
std::string cut_typedef(std::string line) // cut typedef from the beginning
{
	if(line.compare(0,8,"typedef ")==0)
	{
		return line.substr(8);
	}
	else return line;	
}

int count(std::string line) //count all < in string
{
	int number = 0;
	for(int i = 0;i<line.length();i++)
	{
		if(line[i]=='<') number+=1;
	}
	return number;
}

bool is_transition(const std::string line)
{
	int pos = line.find("::");
	if(pos==10)
	{
		if(line.compare(0,22,"statechart::transition")==0)
		{
			return true;	
		}
		else
		{
			std::string str = line.substr(pos+2);
			if(str.compare(0,10,"transition")==0)return true;
		}
	}
	else
	{
		std::string str = line.substr(pos+2);
		//std::cout<<str;
		if(str.compare(0,10,"transition")==0)return true;
	}
	return false;
}

std::string get_transition_params(std::string line)
{
	int pos_front = line.find("<")+1;
	int pos_end = line.find(">");
	std::string first[2];
	std::string params;
	params = line.substr(pos_front,pos_end-pos_front);
	return params;
	
}

