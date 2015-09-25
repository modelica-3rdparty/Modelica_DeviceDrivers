/** Test for MDDSharedMemory.
 *
 * @file
 * @author      bernhard-thiele
 * @since       2012-06-04
 * @copyright Modelica License 2
 * @test Test for MDDSharedMemory.h.
*/

#include <stdio.h>
#include "../../Include/MDDSharedMemory.h"

#define M_LENGTH (80)

int main(void) {
    void *smb1, *smb2;
    int i;
    const char* semname = "/test5";
    char sendMessage[M_LENGTH];
    const char *recMessage;

    printf("Testing MDDSharedMemory\n");

    smb1 = MDD_SharedMemoryConstructor(semname, M_LENGTH);
    if (smb1 == 0) {
        perror("smb1 == NULL\n");
        exit(1);
    }

    smb2 = MDD_SharedMemoryConstructor(semname, M_LENGTH);
    if (smb2 == 0) {
        MDD_SharedMemoryDestructor(smb1);
        perror("smb2 == NULL\n");
        exit(1);
    }

    for (i=0; i < 10; i++) {
        sprintf(sendMessage, "Current i is %i", i);
        MDD_SharedMemoryWrite(smb1, sendMessage, M_LENGTH);
        printf("Sent: %s\n", sendMessage);
        recMessage = MDD_SharedMemoryRead(smb2);
        printf("Received: %s\n", recMessage);
    }

    printf("Buffer size smb1: %d\n", MDD_SharedMemoryGetDataSize(smb1));
    printf("Buffer size smb2: %d\n", MDD_SharedMemoryGetDataSize(smb2));

    MDD_SharedMemoryDestructor(smb1);
    MDD_SharedMemoryDestructor(smb2);

    return 0;
}
