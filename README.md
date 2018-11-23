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



## Aserciones



En la siguiente tabla se muestra la descripción de las reglas 3.00, 3.05, 3.10, 3.25, 3.35; obtenido de la revisión b4 de WISHBONE.


| # Rule | Description                                                                                                                                                                                                                                                                                                          |
|--------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 3.00   | All WISHBONE interfaces MUST initialize themselves at the rising [CLK_I] edge following the assertion of [RST_I]. They MUST stay in the initialized state until the rising [CLK_I]edge that follows the negation of [RST_I].                                                                                         |
| 3.05   | [RST_I] MUST be asserted for at least one complete clock cycle on all WISHBONE Interfaces.                                                                                                                                                                                                                           |
| 3.10   | All WISHBONE interfaces MUST be capable of reacting to [RST_I] at any time.                                                                                                                                                                                                                                          |
| 3.15   | All self-starting state machines and counters in WISHBONE interfaces MUST initialize themselves at the rising [CLK_I] edge following the assertion of [RST_I]. They MUST stay in the initialized state until the rising [CLK_I] edge that follows the negation of [RST_I].                                           |
| 3.25   | MASTER interfaces MUST assert [CYC_O] for the duration of SINGLE READ / WRITE, BLOCK and RMW cycles. [CYC_O] MUST be asserted no later than the rising [CLK_I] edge that qualifies the assertion of [STB_O]. [CYC_O] MUST be negated no earlier than the rising [CLK_I] edge that qualifies the negation of [STB_O]. |
| 3.35   | In standard mode the cycle termination signals [ACK_O], [ERR_O], and [RTY_O] must be generated in response to the logical AND of [CYC_I] and [STB_I]|

Se empieza afirmando que todas las interfaces de WISHBONE DEBEN de inicializarse en el flanco positivo de la señal [CLK_I] y la aserción de la señal [RST_I]. Se deben mantener en estado inicial hasta que se tenga la negación de la señal [RST_I]. Para que el reinicio de todas las interfaces WISHBONE se lleven a cabo, la señal [RST_I] debe mantenerse en aserción por lo menos un ciclo de reloj. 

En el caso de los MASTERS, se cumple que:

- Los ciclos de reinicio pueden extenderse por cualquier período de tiempo.
- Las máquinas de estado y los contadores se reinician en el flanco positivo de la señal [CLK_I] que sigue a la aserción de [RST_I]. [STB_O] y [CYC_O] se niegan al mismo tiempo.
- Después de la negación de [RST_I], las señales [STB_O] y [CYC_O] pueden estar en aserción en el flanco positivo de [CLK_I].

Donde: 
- **[STB_O]** es el "Strobe Output" e indica cuando se termina correctamente un ciclo de transferencia de datos
- **[CYC_O]** es el "Cycle Output" e indica que un ciclo de bus válido está en progreso. Aplica durante los ciclos de "SINGLE READ / WRITE, BLOCK y RMW"


![](https://github.com/manchii/Proyecto_VF/blob/master/images/reset_master.png)

En el caso [CYC_O]:
- DEBE confirmarse a más tardar en el flanco positivo de [CLK_I] que califica la aserción de [STB_O].
- DEBE ser negado no antes del flanco positivo de [CLK_I] que califica la negación de [STB_O].

En modo estándar, las señales de terminación de ciclo [ACK_O], [ERR_O] y [RTY_O] deben generarse en respuesta al AND lógico de las señales [CYC_I] y [STB_I]

Considerando que en una conexión estándar [CYC_I] se conecta con [CYC_o] y que [STB_I] se conecta con [STB_O], las aserción se puede obtener mediante la respuesta al AND lógico de las señales [CYC_O] y [STB_O]. 

![](https://github.com/manchii/Proyecto_VF/blob/master/images/conexion_estandar.png)






