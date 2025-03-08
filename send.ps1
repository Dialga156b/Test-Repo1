// sender.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 12345
#define BUFFER_SIZE 1024

int main() {
    int sock = 0;
    struct sockaddr_in serv_addr;
    char message[BUFFER_SIZE];
    char server_ip[100];

    // Ask for the receiver's IP address
    printf("Enter receiver's IP address: ");
    if (fgets(server_ip, sizeof(server_ip), stdin) == NULL) {
        fprintf(stderr, "Error reading IP address.\n");
        return 1;
    }
    server_ip[strcspn(server_ip, "\n")] = '\0'; // remove newline

    // Create a TCP socket
    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        perror("Socket creation error");
        return -1;
    }

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);

    // Convert IP address from text to binary form
    if (inet_pton(AF_INET, server_ip, &serv_addr.sin_addr) <= 0) {
        perror("Invalid address/ Address not supported");
        return -1;
    }

    // Connect to the receiver
    if (connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        perror("Connection Failed");
        return -1;
    }
    printf("Connected to %s:%d\n", server_ip, PORT);
    printf("Type your message and press enter (Ctrl+C to exit):\n");

    // Continuously send messages typed by the user
    while (1) {
        if (fgets(message, BUFFER_SIZE, stdin) != NULL) {
            message[strcspn(message, "\n")] = '\0'; // remove newline
            if (strlen(message) == 0)
                continue;
            send(sock, message, strlen(message), 0);
            printf("Message sent.\n");
        }
    }

    close(sock);
    return 0;
}
