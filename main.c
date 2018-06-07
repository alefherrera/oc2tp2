int main(int argc, char** argv) {

  //for (int i = 1; i < argc; i++) {
    char *img1 = argv[0];
    char *img2 = argv[1];
    int filas = atoi(argv[2]);
    int columnas = atoi(argv[3]);
    int n = atoi(argv[4]);
    char *resultado = argv[5];
  //}

  return 0;
}

int leer_rgb(char *archivo, unsigned char *buffer, int filas, int columnas) {
  FILE *file;
  file = fopen(archivo, "r");
  fread(buffer, filas * columnas, 1, file);
  fclose(file);
}

int escribir_rgb(char *archivo, unsigned char *buffer, int filas, int columnas) {
  FILE *file;
  file = fopen(archivo, "w");
  fwrite(buffer, filas * columnas, 1, file);
  fclose(file);
}

void interpolar(unsigned char *img1, unsigned char *img2, unsigned char *resultado, float p, int cantidad) {

}
