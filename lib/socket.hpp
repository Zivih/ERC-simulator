#ifdef _linux_
    #include <unistd.h>
    #include <sys/socket.h>
    #include <arpa/inet.h>
    #include <netdb.h>

#elif _WIN32
    #include <windows.h>
    #include <winsock.h>
    #include <ws2tcpip.h>

#else
    #error "OS not supported"

#endif