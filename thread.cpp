#include "lib\libstd.hpp"

#ifdef __linux__

    Thread::Thread(void *(*function) (void *), void *arg){
        pthread_t thisTh;
        pthread_create(&thisTh, NULL, function, arg);
    }

    void Thread::print(){
        std::cout << "ciao" << std::endl;
    }

#elif _WIN32

    Thread::Thread(void *(*function) (void *), void *arg) {
        PMYDATA pDataArray[MAX_THREADS];
        DWORD   dwThreadIdArray[MAX_THREADS];
        HANDLE  hThreadArray[MAX_THREADS]; 

        // Create MAX_THREADS worker threads.

        for( int i=0; i<MAX_THREADS; i++ ) {
            // Allocate memory for thread data.

            pDataArray[i] = (PMYDATA) HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY,
                    sizeof(MYDATA));

            if( pDataArray[i] == NULL ) {
            // If the array allocation fails, the system is out of memory
            // so there is no point in trying to print an error message.
            // Just terminate execution.
                ExitProcess(2);
            }

            // Generate unique data for each thread to work with.

            pDataArray[i]->val1 = i;
            pDataArray[i]->val2 = i+100;

            // Create the thread to begin execution on its own.

            hThreadArray[i] = CreateThread( 
                NULL,                   // default security attributes
                0,                      // use default stack size  
                MyThreadFunction,       // thread function name
                pDataArray[i],          // argument to thread function 
                0,                      // use default creation flags 
                &dwThreadIdArray[i]);   // returns the thread identifier 


            // Check the return value for success.
            // If CreateThread fails, terminate execution. 
            // This will automatically clean up threads and memory. 

            if (hThreadArray[i] == NULL) {
            //ErrorHandler(TEXT("CreateThread"));
            ExitProcess(3);
            }
        } // End of main thread creation loop.

        // Wait until all threads have terminated.

        WaitForMultipleObjects(MAX_THREADS, hThreadArray, TRUE, INFINITE);

        // Close all thread handles and free memory allocations.

        for(int i=0; i<MAX_THREADS; i++) {
            CloseHandle(hThreadArray[i]);
            if(pDataArray[i] != NULL) {
                HeapFree(GetProcessHeap(), 0, pDataArray[i]);
                pDataArray[i] = NULL;    // Ensure address is not reused.
            }
        }
    }
    
    void Thread::print(){
        std::cout << "ciao" << std::endl;
    }
    void *myfun(void *c){
        std::cout << *(int *)c << std::endl;
        pthread_exit(NULL);
    }
    void *mysecondfun(void *){
        std::cout << "Second!" << std::endl;
        pthread_exit(NULL);
    }
#else
    #error "OS not supported"

#endif

/*
int main(int argc, char **argv){
    Thread *c = new Thread(myfun,new int(5));
    Thread *b = new Thread(mysecondfun,NULL);
    sleep(2);
    c->print();
    free(c);
    free(b);
}
*/
