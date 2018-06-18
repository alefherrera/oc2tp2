#include <stdio.h>
#include <stdlib.h>

void interpolar(unsigned char *img1, unsigned char *img2, unsigned char *resultado, float p, int cantidad);
int leer_rgb(char *archivo, unsigned char *buffer, int filas, int columnas);
int escribir_rgb(char *archivo, unsigned char *buffer, int filas, int columnas);

int main(int argc, char **argv)
{
  //for (int i = 1; i < argc; i++) {
  char *img1 = argv[1];
  char *img2 = argv[2];
  int filas = atoi(argv[3]);
  int columnas = atoi(argv[4]);
  int n = atoi(argv[5]);
  char *resultado = argv[6];

  printf("Img1: %s\n", img1);
  printf("Img2: %s\n", img2);
  printf("Filas: %d\n", filas);
  printf("Columnas: %d\n", columnas);
  printf("N: %d\n", n);
  printf("Resultado: %s\n", resultado);  
  //}


  int cantidad = filas * columnas * 3;

  unsigned char *buffer1 = malloc(cantidad);
  unsigned char *buffer2 = malloc(cantidad);
  unsigned char *bufferResult = malloc(cantidad);

  leer_rgb(img1, buffer1, filas, columnas);
  leer_rgb(img2, buffer2, filas, columnas);

  interpolar(buffer1, buffer2, bufferResult, 1.0f, cantidad);

  printf("Antes de escribir\n");
  printf("Buffer1: %s\n", buffer1);
  printf("Buffer2: %s\n", buffer2);
  printf("BufferResult: %s\n", bufferResult);
  
  escribir_rgb("asd.rgb", buffer1, filas, columnas);
  escribir_rgb(resultado, bufferResult, filas, columnas);
  printf("Despues de escribir\n");

  return 0;
}

int leer_rgb(char *archivo, unsigned char *buffer, int filas, int columnas)
{
  FILE *file;
  file = fopen(archivo, "r");
  fread(buffer, filas * columnas * 3, 1, file);
  return fclose(file);
}

int escribir_rgb(char *archivo, unsigned char *buffer, int filas, int columnas)
{
  printf("EscribirRGB: %s, %s, %d, %d\n", archivo, buffer, filas, columnas);  
  FILE *file;
  printf("Antes de FOpen\n");
  file = fopen(archivo, "w");
  printf("Despues de FOpen, Antes de fwrite.\n");
  fwrite(buffer, filas * columnas * 3, 1, file);
  printf("Despues de fwrite.\n");
  return fclose(file);
}