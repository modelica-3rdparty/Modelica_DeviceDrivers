/** Test for MDDTCPIPSocket.
 *
 * @file
 * @author      Bernhard Thiele <bernhard.thiele@dlr.de>
 * @since       2012-05-30
 * @copyright Modelica License 2
 * @test Test for MDDTCPIPSocket.h.
*/

#include <stdio.h>
#include "../../Include/MDDTCPIPSocket.h"
#include "../../src/include/util.h" /* Sleep(..) */

int main(void) {
    void * client;
    char sendMessage[80];
    const char *recMessage;
    int i;

    client = MDD_TCPIPClient_Constructor("localhost", 27015);
    if (client == 0) {
        perror("client == NULL\n");
        exit(EXIT_FAILURE);
    }

    for (i=0; i < 10; i++) {
        sprintf(sendMessage, "Current i is %i", i);
        MDD_TCPIPClient_Send(client, sendMessage, 80);
        Sleep(250);
        recMessage = MDD_TCPIPClient_Read(client, 80);
        printf("Received: %s\n", recMessage);
    }

    MDD_TCPIPClient_Destructor(client);

    return EXIT_SUCCESS;
}
