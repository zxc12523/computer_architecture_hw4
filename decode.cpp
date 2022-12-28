#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<algorithm>
#include<vector>
#include<map>
#include<unordered_map>
#include<queue>
#include<set>
#include <unordered_set>
#include<stack>
#include<iostream>
#include <iomanip>
#include<math.h>
#include<string>


using namespace std;


FILE *fp;

unsigned int binstr2int(string s) {
    int ret = 0;

    for(int i=0;i<s.size();i++) {
        ret *= 2;
        if (s[i] == '1')
            ret += 1;
    }

    return ret;
}

void decode(string s) {
    string fun7(s.begin(), s.begin()+7);
    string rs2(s.begin()+7, s.begin()+12);
    string rs1(s.begin()+12, s.begin()+17);
    string fun3(s.begin()+17, s.begin()+20);
    string rd(s.begin()+20, s.begin()+25);
    string opcode(s.begin() + 25, s.end());

    // cout << "fun7 " << binstr2int(fun7) << '\n';
    // cout << "rs2 " << binstr2int(rs2) << '\n';
    // cout << "rs1 " << binstr2int(rs1) << '\n';
    // cout << "fun3 " << binstr2int(fun3) << '\n';
    // cout << "rd " << binstr2int(rd) << '\n';
    // cout << "opcode " << binstr2int(opcode) << '\n';

    if (opcode == "0000011") {
        string imm(s.begin(), s.begin()+12);
        fprintf(fp, "ld   x%03x %03x(x%03x)\n", binstr2int(rd), binstr2int(imm), binstr2int(rs1));
    }
    else if (opcode == "0100011") {
        string imm(s.begin(), s.begin()+7);
        string imm1(s.begin()+20, s.begin()+25);
        imm += imm1;
        fprintf(fp, "sd   x%03x %03x(x%03x)\n", binstr2int(rs2), binstr2int(imm), binstr2int(rs1));
    }
    else if (opcode == "1100011") {
        string imm(s.begin(), s.begin()+1);
        string imm1(s.begin()+1, s.begin()+7);
        string imm2(s.begin()+20, s.begin()+24);
        string imm3(s.begin()+24, s.begin()+25);

        imm += imm3 + imm1 + imm2 + '0';

        if (imm[0] == '1') {
            for(int i=0;i<imm.size();i++) {
                if (imm[i] == '1') {
                    imm[i] = '0';
                }
                else {
                    imm[i] = '1';
                }
            }

            int c = 0;
            int a = 1;

            for(int i=imm.size()-1;i>=0;i--) {
                int sum = imm[i] - '0' + c + a;

                if (sum >= 2) {
                    imm[i] = '0' + (sum % 2);
                }
                else {
                    imm[i] = '0' + sum;
                }

                c = sum / 2;
                a = 0;
            }
        }

        if (fun3[2] == '0') {
            if (s[0] == '0') {
                fprintf(fp, "beq  x%03x x%03x %03x\n", binstr2int(rs2), binstr2int(rs1), binstr2int(imm));
            }
            else {
                fprintf(fp, "beq  x%03x x%03x -%03x\n", binstr2int(rs2), binstr2int(rs1), binstr2int(imm));
            }
        }
        else {
            if (s[0] == '0') {
                fprintf(fp, "bne  x%03x x%03x %03x\n", binstr2int(rs2), binstr2int(rs1), binstr2int(imm));
            }
            else {
                fprintf(fp, "bne  x%03x x%03x -%03x\n", binstr2int(rs2), binstr2int(rs1), binstr2int(imm));
            }
        }

    }
    else if (opcode == "0010011") {
        string imm(s.begin(), s.begin()+12);
        if (fun3 == "000") {
            fprintf(fp, "addi x%03x x%03x %03x\n", binstr2int(rd), binstr2int(rs1), binstr2int(imm));
        }
        else if (fun3 == "100") {
            fprintf(fp, "xori x%03x x%03x %03x\n", binstr2int(rd), binstr2int(rs1), binstr2int(imm));
        }
        else if (fun3 == "110") {
            fprintf(fp, "ori x%03x x%03x %03x\n", binstr2int(rd), binstr2int(rs1), binstr2int(imm));
        }
        else if (fun3 == "111") {
            fprintf(fp, "andi x%03x x%03x %03x\n", binstr2int(rd), binstr2int(rs1), binstr2int(imm));
        }
        else if (fun3 == "001") {
            fprintf(fp, "slli x%03x x%03x %03x\n", binstr2int(rd), binstr2int(rs1), binstr2int(imm));
        }
        else if (fun3 == "101"){
            fprintf(fp, "srli x%03x x%03x %03x\n", binstr2int(rd), binstr2int(rs1), binstr2int(imm));
        }
    }
    else if (opcode == "0110011") {
        if (fun7 == "0000000" && fun3 == "000") {
            fprintf(fp, "add  x%03x x%03x x%03x\n", binstr2int(rd), binstr2int(rs1), binstr2int(rs2));
        }
        else if (fun7 == "0100000" && fun3 == "000") {
            fprintf(fp, "sub  x%03x x%03x x%03x\n", binstr2int(rd), binstr2int(rs1), binstr2int(rs2));
        }
        else if (fun7 == "0000000" && fun3 == "100") {
            fprintf(fp, "xor  x%03x x%03x x%03x\n", binstr2int(rd), binstr2int(rs1), binstr2int(rs2));
        }
        else if (fun7 == "0000000" && fun3 == "110") {
            fprintf(fp, "or   x%03x x%03x x%03x\n", binstr2int(rd), binstr2int(rs1), binstr2int(rs2));
        }
        else if (fun7 == "0000000" && fun3 == "111") {
            fprintf(fp, "and  x%03x x%03x x%03x\n", binstr2int(rd), binstr2int(rs1), binstr2int(rs2));
        }
    }
    else {
        fprintf(fp, "finish\n");
    }
}

signed main() {
    vector<string> vec;

    int n;
    string s;
    int pc = 0;

    fp = fopen("small_workload2_asm.txt", "w+");

    cin >> n;

    for(int i=0;i<n;i++) {
        cin >> s;
        fprintf(fp, "%02x: ", pc);
        pc += 4;
        decode(s);
    }
}