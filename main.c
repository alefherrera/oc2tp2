#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void interpolar(unsigned char *img1, unsigned char *img2, unsigned char *resultado, float p, int cantidad);
int leer_rgb(char *archivo, unsigned char *buffer, int filas, int columnas);
int escribir_rgb(char *archivo, unsigned char *buffer, int filas, int columnas);
void printChar(unsigned char *buffer);

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

  interpolar(buffer1, buffer2, bufferResult, 0.5, cantidad);

  printf("Antes de escribir\n");
  printf("Buffer1:        ");
  printChar(buffer1);
  printf("Buffer2:        ");
  printChar(buffer2);
  printf("BufferResult:   ");
  printChar(bufferResult);

  escribir_rgb(resultado, bufferResult, filas, columnas);

  return 0;
}

int leer_rgb(char *archivo, unsigned char *buffer, int filas, int columnas)
{
  printf("Leer_rgb: Archivo: %s, BufferLength: %d, Filas: %d, Columnas: %d\n", archivo, strlen((char *)buffer), filas, columnas);
  FILE *file;
  file = fopen(archivo, "r");
  fread(buffer, filas * columnas * 3, 1, file);
  printf("Leer_rgb fin: Archivo: %s, BufferLength: %d, Filas: %d, Columnas: %d\n", archivo, strlen((char *)buffer), filas, columnas);
  return fclose(file);
}

int escribir_rgb(char *archivo, unsigned char *buffer, int filas, int columnas)
{
  printf("Escribir_rgb: Archivo: %s, BufferLength: %d\n", archivo, strlen((char *)buffer));
  FILE *file;
  file = fopen(archivo, "w+");
  fwrite(buffer, filas * columnas * 3, 1, file);
  printf("Escribir_rgb fin: Archivo: %s, BufferLength: %d\n", archivo, strlen((char *)buffer));
  return fclose(file);
}

void printChar(unsigned char *buffer)
{
  for (int i = 0; i < strlen((char *)buffer); i++)
  {
    printf("%x ", (int)buffer[i]);
  }
  printf("\n");
}