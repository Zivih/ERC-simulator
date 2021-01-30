#include "lib\libstd.hpp"

#define BUFSIZE 102400 //max uint32_t

class Client{
public:
    Client(){
        sock = socket(AF_INET,SOCK_STREAM,0);
        if(sock < 0){
           std::cout << "Errore nella creazione del socket" << std::endl;
            return;
        }

    }
    void connect(const char *serverip, uint16_t port ){
        //std::cout << port << std::endl;
        struct sockaddr_in serverAddress;
        struct hostent *server;
        memset(&serverAddress, 0, sizeof(struct sockaddr_in));
        serverAddress.sin_family = AF_INET;
        serverAddress.sin_port = htons(port);
        server = gethostbyname(serverip);
        bcopy((char *)server->h_addr,
            (char *)&serverAddress.sin_addr.s_addr,
            server->h_length);
        if (::connect(sock, (struct sockaddr *)&serverAddress, sizeof(serverAddress)) < 0) { 
            printf("Connection Failed \n"); 
            return; 
        }
        connected = 1;
        th = new Thread(receiveThread,this);
    }
    static void *receiveThread(void *arg){
        Client *self = (Client *)arg;
        char buff[BUFSIZE];
        while ((Client *)self->connected){
            recv(self->sock,&buff,BUFSIZE,0);
            //std::cout << "Obj: "<< buff;
            //find first occurence of \n
            //add command to parser
            //next occurence of \n
            //add command
            //continue until iterator is == \0
            char *offset = &buff[0];
            uint32_t ioff = 0;
            char out[BUFSIZE];
            //eventualmente questo potrebbe andare in un thread di parsing ed esecuzione piùttosto che rallentare tutto
            for (uint32_t i = 0;i < BUFSIZE;i++){
                if(buff[i] == '\0') break;
                if(buff[i] == '\n'){
                    bzero(out,BUFSIZE);
                    bcopy(offset, &out[0], i - ioff);
                    offset = &buff[i+1];
                    ioff = i+1;
                    std::cout << "Obj: "<< out << std::endl;
                    try{
                        nlohmann::json j = nlohmann::json::parse(out);
                        if (j["updateBatt"] != nlohmann::detail::value_t::null){
                            std::cout << j["updateBatt"] << std::endl;
                        }
                        //passing j to function handler
                        for(std::map<char *, void (*) (nlohmann::json *j)>::iterator iter = self->functions.begin(); iter != self->functions.end(); ++iter){
                            char *name =  iter->first;
                            if (j[name] != nlohmann::detail::value_t::null){
                                self->functions[name](&j);
                            }
                            //ignore value
                            //Value v = iter->second;
                        }
                    }
                    catch(nlohmann::detail::parse_error){
                        std::cout << "Errore^\n";
                    }
                }
            }

            bzero(&buff, BUFSIZE);
        }
        pthread_exit(NULL);
    }
    int send(const char *msg){
        if (!connected) return -1;
        size_t len = strlen(msg);
        if (::send(sock, msg, len, 0) < 0){
            std::cout << "Errore di invio" << std::endl;
            connected = 0;
            return -1;
        }
        return 0;
    }
    void registerFunction(char *name,void (*fun) (nlohmann::json *j)){
        functions[name] = fun;
    }
    // quando ricevi una certa stringa chiama la funzione associata nella mappa se presente
    // gli argomenti delle funzioni devono essere gli stessi, usare struct o classe template?
    // da un punto di vista implementamentativo nella mia classe chiamerei Client client = ...
    // client.registerFunction("funzionedachiamare", funzionedachiamare)
    // dovrei fare un overload troppo spinto
private:
    int sock = 0;
    bool connected = 0;
    Thread *th;
    std::map <char *,void (*)(nlohmann::json *)> functions;
};

void updateAccel(nlohmann::json *j){
    std::cout << "yeee - " << (*j)["updateAccel"] << std::endl;
}

int main(int argc, char **argv){
    Client client = Client();
    client.registerFunction("updateAccel", updateAccel);
    client.connect("127.0.0.1",12345);
    client.send("{\"move\":[1,2]}\n");
    sleep(3);
    client.send("{\"stop\":0}\n");
    sleep(1);
    return 0;
}