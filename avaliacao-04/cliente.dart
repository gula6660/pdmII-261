import 'dart:io';
import 'dart:async';
import 'dart:math';

void main() async {
  print('Dispositivo IOT de Monitoramento de Temperatura');
  print('===============================================');
  
  const String serverAddress = 'localhost';
  const int serverPort = 8080;
  
  Random random = Random();
  int readingCount = 0;
  bool isConnected = true;  // ✅ Usar uma variável booleana para controlar o estado
  
  try {
    print('Conectando ao servidor em $serverAddress:$serverPort...');
    Socket socket = await Socket.connect(serverAddress, serverPort);
    print('Conectado ao servidor com sucesso!\n');
    
    socket.listen(
      (List<int> data) {
        String response = String.fromCharCodes(data);
        print('Servidor respondeu: $response');
      },
      onError: (error) {
        print('Erro na conexão com servidor: $error');
        isConnected = false;  // ✅ Marca como desconectado
      },
      onDone: () {
        print('Conexão com servidor encerrada');
        isConnected = false;  // ✅ Marca como desconectado
        exit(0);
      },
    );
    
    double generateTemperature() {
      double baseTemp = 25.0;
      double variation = (random.nextDouble() * 10) - 5;
      return baseTemp + variation;
    }
    
    void sendTemperature() {
      readingCount++;
      double temperature = generateTemperature();
      String message = 'TEMPERATURA:${temperature.toStringAsFixed(1)}\n';
      
      DateTime now = DateTime.now();
      print('[${now.toLocal().toString()}] Enviando leitura #$readingCount: ${temperature.toStringAsFixed(1)}°C');
      
      socket.write(message);
    }
    
    sendTemperature();
    
    Timer.periodic(Duration(seconds: 10), (Timer timer) {
      if (isConnected) {  // ✅ Usa a variável booleana
        sendTemperature();
      } else {
        print('Conexão encerrada, interrompendo envio de dados...');
        timer.cancel();
      }
    });
    
    print('\nMonitorando temperatura... (Ctrl+C para encerrar)');
    print('================================================\n');
    
    await ProcessSignal.sigint.watch().first;
    print('\n\nEncerrando dispositivo IOT...');
    isConnected = false;
    await socket.close();
    exit(0);
    
  } catch (e) {
    print('Erro ao conectar ao servidor: $e');
    print('Verifique se o servidor está rodando na porta $serverPort');
    exit(1);
  }
}