#include "thread.hpp"


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
Thread::Thread(void *(*function) (void *), void *arg){

    pthread_t thisTh;
    pthread_create(&thisTh, NULL, function, arg);
}

void Thread::print(){
    std::cout << "nonmecagaerca" << std::endl;
}
void *myfun(void *c){
    std::cout << *(int *)c << std::endl;
    pthread_exit(NULL);
}
void *mysecondfun(void *){
    std::cout << "Second!" << std::endl;
    pthread_exit(NULL);
}