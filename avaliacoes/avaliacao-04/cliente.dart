import 'dart:io';
import 'dart:async';
import 'dart:math';

void main() async {
  print('Dispositivo IOT de Monitoramento de Temperatura');
  print('===============================================');
  
  // Configurações do servidor
  const String serverAddress = 'localhost';
  const int serverPort = 8080;
  
  Random random = Random();
  int readingCount = 0;
  
  try {
    // Conecta ao servidor
    print('Conectando ao servidor em $serverAddress:$serverPort...');
    Socket socket = await Socket.connect(serverAddress, serverPort);
    print('Conectado ao servidor com sucesso!\n');
    
    // Escuta respostas do servidor (opcional)
    socket.listen(
      (List<int> data) {
        String response = String.fromCharCodes(data);
        print('Servidor respondeu: $response');
      },
      onError: (error) {
        print('Erro na conexão com servidor: $error');
      },
      onDone: () {
        print('Conexão com servidor encerrada');
        exit(0);
      },
    );
    
    // Função para gerar temperatura simulada (entre 15°C e 35°C)
    double generateTemperature() {
      double baseTemp = 25.0; // Temperatura base
      double variation = (random.nextDouble() * 10) - 5; // -5 a +5
      return baseTemp + variation;
    }
    
    // Função para enviar leitura de temperatura
    void sendTemperature() {
      readingCount++;
      double temperature = generateTemperature();
      String message = 'TEMPERATURA:${temperature.toStringAsFixed(1)}\n';
      
      DateTime now = DateTime.now();
      print('[${now.toLocal().toString()}] Enviando leitura #$readingCount: ${temperature.toStringAsFixed(1)}°C');
      
      socket.write(message);
    }
    
    // Envia primeira leitura imediatamente
    sendTemperature();
    
    // Configura timer para enviar leituras a cada 10 segundos
    Timer.periodic(Duration(seconds: 10), (Timer timer) {
      if (!socket.isClosed) {
        sendTemperature();
      } else {
        print('Socket fechado, encerrando envio de dados...');
        timer.cancel();
      }
    });
    
    // Mantém o programa rodando até Ctrl+C
    print('\nMonitorando temperatura... (Ctrl+C para encerrar)');
    print('================================================\n');
    
    // Aguarda sinal de interrupção
    await ProcessSignal.sigint.watch().first;
    print('\n\nEncerrando dispositivo IOT...');
    await socket.close();
    exit(0);
    
  } catch (e) {
    print('Erro ao conectar ao servidor: $e');
    print('Verifique se o servidor está rodando na porta $serverPort');
    exit(1);
  }
}
