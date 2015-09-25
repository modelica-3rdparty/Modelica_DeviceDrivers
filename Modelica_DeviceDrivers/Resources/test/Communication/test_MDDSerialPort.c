/** Test for MDDSerialPort.
 *
 * @file
 * @author      bernhard-thiele
 * @since       2015-03-23
 * @copyright Modelica License 2
 * @test Test for MDDSerialPort.h.
*/

#include <stdio.h>
#include "../../Include/MDDSerialPort.h"

#define M_LENGTH (80)

int main(void) {
    void *sp1, *sp2;
    int i;
#if defined(WIN32)
    const char* sendName = "\\\\.\\COM6";
    const char* recName = "\\\\.\\COM7";
#else
    const char* sendName = "/dev/pts/1";
    const char* recName = "/dev/pts/3";
#endif
    char sendMessage[M_LENGTH];
    const char *recMessage;
    int recBytes;

    printf("Testing MDDSerialPort\n");

    sp1 = MDD_serialPortConstructor(sendName, M_LENGTH, 0, 0, 5);
    if (sp1 == 0) {
        perror("sp1 == NULL\n");
        exit(1);
    }

    sp2 = MDD_serialPortConstructor(recName, M_LENGTH, 0, 1, 5);
    if (sp2 == 0) {
        MDD_serialPortDestructor(sp1);
        perror("sp2 == NULL\n");
        exit(1);
    }

    for (i=0; i < 10; i++) {
        sprintf(sendMessage, "Current i is %i", i);
        MDD_serialPortSend(sp1, sendMessage, M_LENGTH);
        printf("Sent: %s\n", sendMessage);
        recBytes = MDD_serialPortGetReceivedBytes(sp2);
        recMessage = MDD_serialPortRead(sp2);
        printf("Received %d bytes: %s\n", recBytes, recMessage);
    }

    MDD_serialPortDestructor(sp1);
    MDD_serialPortDestructor(sp2);

    return 0;
}
