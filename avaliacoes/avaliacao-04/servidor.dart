import 'dart:io';
import 'dart:async';

void main() async {
  // Cria o servidor socket na porta 8080
  final server = await ServerSocket.bind(InternetAddress.anyIPv4, 8080);
  print('Servidor IOT aguardando conexões na porta 8080...');

  // Aguarda conexões de clientes IOT
  await for (Socket socket in server) {
    print('Dispositivo IOT conectado: ${socket.remoteAddress.address}:${socket.remotePort}');
    
    // Processa cada cliente em uma função assíncrona separada
    handleClient(socket);
  }
}

void handleClient(Socket socket) {
  // Acumula os dados recebidos
  List<int> dataBuffer = [];
  
  // Escuta os dados recebidos do socket
  socket.listen(
    (List<int> data) {
      dataBuffer.addAll(data);
      
      // Tenta processar mensagens completas (separadas por newline)
      String completeData = String.fromCharCodes(dataBuffer);
      List<String> messages = completeData.split('\n');
      
      // Processa todas as mensagens completas
      for (int i = 0; i < messages.length - 1; i++) {
        String message = messages[i].trim();
        if (message.isNotEmpty) {
          processTemperatureReading(message, socket);
        }
      }
      
      // Mantém o último fragmento incompleto no buffer
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
    // Espera receber dados no formato "TEMPERATURA:XX.X"
    if (message.startsWith('TEMPERATURA:')) {
      String tempStr = message.substring('TEMPERATURA:'.length);
      double temperature = double.parse(tempStr);
      
      // Obtém timestamp atual
      DateTime now = DateTime.now();
      String timestamp = now.toLocal().toString();
      
      // Exibe a temperatura recebida no terminal
      print('\n[$timestamp] Temperatura recebida do dispositivo ${socket.remoteAddress.address}:');
      print('${temperature.toStringAsFixed(1)}°C');
      
      // Opcional: Envia confirmação de recebimento
      socket.write('OK: Temperatura $temperature°C registrada\n');
    } else {
      print('Mensagem inválida recebida: $message');
    }
  } catch (e) {
    print('Erro ao processar temperatura: $e');
  }
}

