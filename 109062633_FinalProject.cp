#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include<cmath>
#include <math.h> 

using namespace std;
using std::string;

int str_to_dex(string a){
	int base = 1, i = 0, result = 0;
	int size = a.size();
	while (i < size)
	{
			if (a[size-i-1] == '1'){
					result = result + base;
			}
			base *= 2;
			i += 1;
	}
	return result;
}

int main(int argc, char *argv[]){
    ifstream cache(argv[1], ios::in);
    ifstream reference(argv[2], ios::in);
    ofstream index(argv[3], ios::ate);
    
    int all_info = 4;
    int cache_info[all_info];  // used to store information about cache
    string line, t;
    int offset_bit, index_count;

    if(cache.is_open()&&index.is_open()&&reference.is_open())
    {   int p = 0;
        while(getline(cache, line)){
            int dex_num = 1;
            int temp = 0;
            for(int j=line.length()-1; j>0; j--){
                if (isdigit(line[j])){
                    temp += (line[j]-'0')*dex_num;
                    dex_num *= 10;
                }
            }
            cache_info[p]=temp;
            p += 1;
        }

        index<<"Address bits: "<<cache_info[0]<<endl;
        index<<"Block size: "<<cache_info[1]<<endl;
        index<<"Cache sets: "<<cache_info[2]<<endl;
        index<<"Associativity: "<<cache_info[3]<<endl;
        
        index<<'\n';
        offset_bit=ceil(log(cache_info[1])/log(2)); // calculate the offset bit
        index_count=ceil(log(cache_info[2])/log(2)); // calculate the index bit count
        
        int tag_length = cache_info[0]-(offset_bit+index_count);

        index<<"Offset bit count: "<<offset_bit<<endl;
        index<<"Indexing bit count: "<<index_count<<endl;
        index<<"Indexing bits: ";
        for(int i=cache_info[0]-tag_length;i>offset_bit;i--){
            index<<i-1<<' ';
        }
        index<<"\n"<<endl;
        
        int cache_size = cache_info[2]*cache_info[3]*2;
        vector<string> whole_cache(cache_size, "1"); // set cache_size and initiate all data to '1'
        int miss_count = 0;

        while(getline(reference, line)){  // while reference file is not empty
            if((line.length()>=cache_info[0]) && (line.find(".bench") == string::npos)){ // skip first line
                string str_index = line.substr(tag_length, index_count); // get index(string)
                int num_index = str_to_dex(str_index); // convert index into integer
                string target_tag = line.substr(0,tag_length);
                int start_index = num_index*cache_info[3]*2;
                bool not_place = true;

                for(int j=start_index;j<start_index+cache_info[3]*2;j+=2){
                    string exist_tag = whole_cache[j];
                    if(whole_cache[j]=="1"){ // tag place = "1" means empty
                        whole_cache[j] = target_tag; // put tag into the empty place
                        whole_cache[j+1] = "0"; // set NRU bit into "0"
                        index<<line<<" "<<"miss"<<endl;
                        miss_count += 1;
                        not_place = false;
                        break;
                    }
                    else if(exist_tag == target_tag){ // check if hit, turn NRU bit to 0
                        whole_cache[j+1] = "0";
                        index<<line<<" "<<"hit"<<endl;
                        not_place = false;
                        break;
                    }
                }
                
                if(not_place){
                    index<<line<<" "<<"miss"<<endl;
                    miss_count += 1;
                    for(int j=start_index;j<start_index+cache_info[3]*2;j+=2){
                        if(whole_cache[j+1]=="1"){  // if encounter NRU = 1
                            whole_cache[j] = target_tag;  // Update tag 
                            whole_cache[j+1] = "0"; // NRU = "0"
                            not_place = false;
                            break;
                        }
                    }
                    
                    // if all NRU=1 then will execute the following part 
                    if(not_place){
                        for(int j=start_index;j<start_index+cache_info[3]*2;j+=2){
                            whole_cache[j+1] = "1";
                        }
                        whole_cache[start_index] = target_tag;
                        whole_cache[start_index+1] = '0'; 
                    }
                } 
            }
            else{
                index<<line<<endl;
            }
        }
        index<<"Total cache miss count: "<< miss_count <<endl;
    }
    
    else{
        cerr << "Could not open the file." << endl;
        return EXIT_FAILURE;
    }
    return 0;
}
