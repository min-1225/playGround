/*package p2941
 
import java.io.*;

public class geminiDebuggedT2 {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String str = sc.next();
        
        // 1. 크로아티아 알파벳 배열 정의
        String[] croatian = {"c=", "c-", "dz=", "d-", "lj", "nj", "s=", "z="};
        
        // 2. 배열을 순회하며 입력받은 문자열 내의 패턴을 한 글자(*)로 치환
        for (String val : croatian) {    // Enhanced for loop 또는 for - each문이라고 부르는 문법.
            if (str.contains(val)) {
                str = str.replace(val, "*");
            }
        }
        
        // 3. 치환된 문자열의 최종 길이를 출력
        System.out.println(str.length());
        
        sc.close();
    }
} */