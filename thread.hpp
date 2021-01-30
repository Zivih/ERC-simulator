#include <iostream>
#include <pthread.h>
#include <unistd.h>

void *myfun(void *c);
void *mysecondfun(void *);

class Thread{
public:
    Thread(void *(*function) (void *), void *arg);
    void print();
    void run();
    void (*threadFunction) ();
};