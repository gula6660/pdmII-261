import 'dart:io';
import 'dart:async';

void main() async {
  final server = await ServerSocket.bind(InternetAddress.anyIPv4, 8080);
  print('Servidor IOT aguardando conexões na porta 8080...');

  await for (Socket socket in server) {
    print('Dispositivo IOT conectado: ${socket.remoteAddress.address}:${socket.remotePort}');
    handleClient(socket);
  }
}

void handleClient(Socket socket) {
  List<int> dataBuffer = [];
  
  socket.listen(
    (List<int> data) {
      dataBuffer.addAll(data);
      
      String completeData = String.fromCharCodes(dataBuffer);
      List<String> messages = completeData.split('\n');
      
      for (int i = 0; i < messages.length - 1; i++) {
        String message = messages[i].trim();
        if (message.isNotEmpty) {
          processTemperatureReading(message, socket);
        }
      }
      
      dataBuffer = messages.last.codeUnits;
    },
    onError: (error) {
      print('Erro na conexão: $error');
    },
    onDone: () {
      print('Dispositivo IOT desconectado: ${socket.remoteAddress.address}:${socket.remotePort}');
      socket.close();
    },
  );
}

void processTemperatureReading(String message, Socket socket) {
  try {
    if (message.startsWith('TEMPERATURA:')) {
      String tempStr = message.substring('TEMPERATURA:'.length);
      double temperature = double.parse(tempStr);
      
      DateTime now = DateTime.now();
      String timestamp = now.toLocal().toString();
      
      print('\n[$timestamp] Temperatura recebida do dispositivo ${socket.remoteAddress.address}:');
      print('${temperature.toStringAsFixed(1)}°C');
      
      socket.write('OK: Temperatura $temperature°C registrada\n');
    } else {
      print('Mensagem inválida recebida: $message');
    }
  } catch (e) {
    print('Erro ao processar temperatura: $e');
  }
}