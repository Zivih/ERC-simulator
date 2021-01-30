#ifdef __linux__
    #include <pthread.h>
    #include <unistd.h>

#elif _WIN32
    #include <windows.h>
    #include <tchar.h>
    #include <strsafe.h>
    #define MAX_THREADS 1

    typedef struct MyData {
        int val1;
        int val2;
    } MYDATA, *PMYDATA;

#else
    #error "OS not supported"

#endif

class Thread{
public:
    Thread(void *(*function) (void *), void *arg);
    void print();
    void run();
    void (*threadFunction) ();
};