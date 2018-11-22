# Proyecto de Verificación Funcional

# Proyecto 1 - SDRAM Controller

## Estrategia de verificación

Se realizan transacciones por el controlador **SDRAM**. Se utiliza un **BMF** de _Wishbone_. Basado en el testbench entregado, se le realiza un ambiente de verificación que incluye instancias de _environment_, _driver_, _scoreboard_ y _monitor_.

### Environment

Crea las instancias y configuración del Driver, Scoreboard y Monitor.

### Driver
Contiene los métodos

* Reset: inicializa la memoria DRAM
* Burst_write: ejecuta una escritura a la memoria DRAM y almacena la información de la escritura en el scoreboard.

### Monitor
Contiene los métodos

* Burst_read: ejecuta una escritura a la memoria DRAM y compara con la información obtenida de la lectura con la información de la escritura almacenada en el scoreboard

### Scoreboard
incluye una cola para datos, dirección, tamaño de ráfaga de escritura.



![](https://raw.githubusercontent.com/manchii/Proyecto_VF/master/images/diagram.png)


# Proyecto 2

## Estrategia de verificación.

Se realiza una extensión del ambiente de verificación del proyecto 1.

![](https://github.com/manchii/Proyecto_VF/blob/master/images/diagram2.png)

Se agrega clase estimulo, donde se definen los casos de prueba mediante a
aleatoriedad y restricciones.

Se modifica el Scoreboard, de forma que pueda manejar escrituras y lecturas en orden y desorden, mediante la adicion de un paramentro aleatorio que seleccione el modo de funcionamiento.

En el RTL se reemplazan todos segmentos de codigo del tipo mostrado a continuacion, por aserciones.

```systemverilog
  always @(posedge wb_clk_i) begin
         if(cmdfifo full == 1'b1 && cmdfifo wr ==1'b1) begin
		     $display ("ERROR:%m COMMAND FIFO WRITE OVERFLOW");
		     end
   end
```

Se agrega un bloque al ambiente de prueba llamado Whitebox, que incluye las senales internas del DUV, como ejemplo:

```systemverilog
Parameter TOP_PATH = top.dut;
Interface whitebox();
logic var;
assign var = `TOP_PATH.module.submodule.signal;
endinterface
```
Se agrega un bloque assertion que incluye aserciones concurrentes para la inicializacion y comprobacion del funcionamiento de la DRAM.

Se agregan aserciones para las reglas 3.00, 3.05, 3.10, 3.25, 3.35 del Wishbone revision b4.









