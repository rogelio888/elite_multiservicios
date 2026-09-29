/// Stub para plataformas no-web (desktop, pruebas unitarias).
void downloadFileWeb(String content, String fileName, String mimeType) {
  // No-op en entornos que no son web.
}

void uploadCsvWeb(void Function(String content) onLoaded) {
  // No-op en entornos que no son web.
}
