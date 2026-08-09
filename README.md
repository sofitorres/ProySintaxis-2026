# 🚀 Tingui Lang - Intérprete y Evaluador Semántico

Este repositorio contiene el código fuente de un intérprete completo desarrollado desde cero en **Free Pascal / Lazarus** para un lenguaje de programación personalizado llamado **Tingui**. 

Este proyecto fue creado como trabajo práctico integrador para la materia **Sintaxis y Semántica de los Lenguajes**, demostrando la aplicación práctica de la teoría de autómatas, gramáticas formales y evaluación de expresiones.

---

## ✨ Características del Motor

El proyecto implementa el ciclo completo de procesamiento de un lenguaje de programación:

1. **Analizador Léxico (`analizadorLexico.pas`):** Lee el código fuente caracter por caracter, ignora espacios/comentarios y tokeniza la entrada mediante una máquina de estados.
2. **Analizador Sintáctico LL(1) (`analizadorSintactico.pas`):** Un parser predictivo no recursivo. Utiliza una Pila y es guiado por una Tabla de Análisis Sintáctico (TAS).
3. **Manejo de Árboles (`manejoArbol.pas`):** Genera y muestra en consola el Árbol de Derivación (Abstract Syntax Tree) que representa la estructura gramatical del código.
4. **Evaluador Semántico (`Evaluador.pas`):** Recorre el árbol generado ejecutando las instrucciones paso a paso, resolviendo la precedencia de operadores lógicos y matemáticos.
5. **Gestión de Memoria (`ManejoEstado.pas`):** Tabla de símbolos en tiempo de ejecución para registrar variables, validar tipos y actualizar valores.

---

## 🛠️ Especificaciones del Lenguaje "Tingui"

El lenguaje soporta tipado estático básico y estructuras de control clásicas:
* **Tipos de datos:** `real` (numéricos) y `string` (cadenas de texto).
* **Operaciones Aritméticas:** Suma (`+`), Resta (`-`), Multiplicación (`*`), División (`/`), Potencia (`^`) y Raíz Cuadrada (`sqrt`).
* **Operadores Relacionales y Lógicos:** `<`, `>`, `=`, `<=`, `>=`, `<>`, `and`, `or`, `not`.
* **Manipulación de Cadenas:** Funciones nativas `largo()`, `subcad()` y `busca()`.
* **Estructuras de Control:** 
  * Condicionales: `if ... then { ... } else { ... }`
  * Ciclos: `while ... do { ... }`
* **I/O:** Funciones `read()` y `write()` para interactuar con la consola.

---

## 🚀 Instalación y Uso

1. Clonar este repositorio en tu máquina local:
   ```bash
   git clone [https://github.com/TU-USUARIO/TU-REPOSITORIO.git](https://github.com/TU-USUARIO/TU-REPOSITORIO.git)
