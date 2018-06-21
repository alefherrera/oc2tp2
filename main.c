#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void interpolar(unsigned char *img1, unsigned char *img2, unsigned char *resultado, float p, int cantidad);
int leer_rgb(char *archivo, unsigned char *buffer, int filas, int columnas);
int escribir_rgb(char *archivo, unsigned char *buffer, int filas, int columnas);
void printChar(unsigned char *buffer);
int obtener_cantidad(int filas, int columnas);

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

  int cantidad = obtener_cantidad(filas, columnas);

  unsigned char *buffer1 = malloc(cantidad);
  unsigned char *buffer2 = malloc(cantidad);
  unsigned char *bufferResult = malloc(cantidad);

  leer_rgb(img1, buffer1, filas, columnas);
  leer_rgb(img2, buffer2, filas, columnas);

  //printf("Antes de escribir\n");
  //printf("Buffer1:        ");
  //printChar(buffer1);
  //printf("Buffer2:        ");
  //printChar(buffer2);

  float variant = 1.0 / (n + 1);
  float p;
  int tope = n + 1;
  char *result = malloc(strlen((char *)resultado) + 5);
  
  for(int i = 1; i < tope; i++) {
    p = variant * i;
    interpolar(buffer1, buffer2, bufferResult, p, cantidad);
    printf("P: %.2f\n", p);
    //printf("BufferResult:   ");
    //printChar(bufferResult);
    sprintf(result, "%s%d.rgb", resultado, i);
    escribir_rgb(result, bufferResult, filas, columnas);
    printf("gm convert -depth 8 -size %dx%d ", filas, columnas);
    printf(" %s%d.rgb", resultado, i);
    printf(" %s%d.bmp \n", resultado, i);
  }

  return 0;
}

int leer_rgb(char *archivo, unsigned char *buffer, int filas, int columnas)
{
  printf("Leer_rgb: Archivo: %s, BufferLength: %d, Filas: %d, Columnas: %d\n", archivo, strlen((char *)buffer), filas, columnas);
  FILE *file;
  file = fopen(archivo, "rb");
  fread(buffer, obtener_cantidad(filas, columnas), 1, file);
  printf("Leer_rgb fin: Archivo: %s, BufferLength: %d, Filas: %d, Columnas: %d\n", archivo, strlen((char *)buffer), filas, columnas);
  return fclose(file);
}

int escribir_rgb(char *archivo, unsigned char *buffer, int filas, int columnas)
{
  printf("Escribir_rgb: Archivo: %s, BufferLength: %d\n", archivo, strlen((char *)buffer));
  FILE *file;
  file = fopen(archivo, "wb+");
  fwrite(buffer, obtener_cantidad(filas, columnas), 1, file);
  printf("Escribir_rgb fin: Archivo: %s, BufferLength: %d\n", archivo, strlen((char *)buffer));
  return fclose(file);
}

int obtener_cantidad(int filas, int columnas) {
  int cantidad = filas * columnas * 3;
  cantidad = cantidad + cantidad % 4;
  return cantidad;
}

void printChar(unsigned char *buffer)
{
  for (int i = 0; i < strlen((char *)buffer); i++)
  {
    printf("%x ", (int)buffer[i]);
  }
  printf("\n");
}