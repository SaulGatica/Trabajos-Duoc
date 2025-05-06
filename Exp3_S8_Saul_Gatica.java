package duoc.exp3_s8_saul_gatica;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

class Entrada {
    static int contador = 1;
    int id;
    String cliente;
    int edad; 
    String funcion;
    int cantidad;
    int[] asientos;
    boolean pagado;
    double precio;
    double descuentoTotal;  // Nuevo campo para mostrar el descuento aplicado
    LocalDateTime fechaDeReserva;
    boolean caducada;

    public Entrada(String cliente, int edad, String funcion, int cantidad, int[] asientos, boolean pagado, double precio, double descuentoTotal) {
        this.id = contador++;
        this.cliente = cliente;
        this.edad = edad;
        this.funcion = funcion;
        this.cantidad = cantidad;
        this.asientos = asientos;
        this.pagado = pagado;
        this.precio = precio;
        this.descuentoTotal = descuentoTotal;
        this.fechaDeReserva = LocalDateTime.now();
        this.caducada = false;
    }

    public boolean esReservaExpirada() {
        return !pagado && !caducada && fechaDeReserva.plusHours(1).isBefore(LocalDateTime.now());
    }

    public void imprimirBoleta() {
        System.out.println("----- BOLETA -----");
        System.out.println("ID: " + id);
        System.out.println("Cliente: " + cliente);
        System.out.println("Edad: " + edad);
        System.out.println("Función: " + funcion);
        System.out.println("Cantidad: " + cantidad);
        System.out.println("Asientos: " + Arrays.toString(asientos));
        System.out.println("Estado: " + (caducada ? "Expirada" : (pagado ? "Comprado" : "Reservado")));
        System.out.println("Descuento total aplicado: $" + descuentoTotal);
        System.out.println("Precio total a pagar: $" + precio);
        System.out.println("------------------");
    }
}

class SistemaTeatro {
    Scanner scanner = new Scanner(System.in);
    List<Entrada> entradas = new ArrayList<>();
    static double ingresosTotales = 0.0;
    static int[] estadoDeAsientos = new int[30]; // 30 asientos

    private int[] seleccionarAsientos(int cantidad) {
        int[] asientosSeleccionados = new int[cantidad];
        System.out.println("Por favor, seleccione " + cantidad + " asiento(s) (números del 1 al 30, separados por espacio): ");
        String input = scanner.nextLine();
        String[] asientosStr = input.split(" ");

        for (int i = 0; i < cantidad; i++) {
            try {
                int asiento = Integer.parseInt(asientosStr[i]);
                if (estadoDeAsientos[asiento - 1] != 0) {
                    System.out.println("El asiento " + asiento + " ya está ocupado.");
                    return new int[0];
                }
                asientosSeleccionados[i] = asiento;
            } catch (Exception e) {
                System.out.println("Error al ingresar número del asiento.");
                return new int[0];
            }
        }

        return asientosSeleccionados;
    }

    private void actualizarReservasExpiradas() {
        for (Entrada e : entradas) {
            if (e.esReservaExpirada()) {
                e.caducada = true;
            }
        }
    }

    public void reservarEntrada() {
        actualizarReservasExpiradas();
        System.out.print("Nombre del cliente: ");
        String cliente = scanner.nextLine();
        System.out.print("Nombre de la función: ");
        String funcion = scanner.nextLine();
        System.out.print("Cantidad de entradas: ");
        int cantidad = Integer.parseInt(scanner.nextLine());

        System.out.print("Ingrese las edades separadas por espacio (" + cantidad + " edades): ");
        String[] edadesStr = scanner.nextLine().split(" ");
        if (edadesStr.length != cantidad) {
            System.out.println("La cantidad de edades no coincide.");
            return;
        }

        int[] edades = new int[cantidad];
        try {
            for (int i = 0; i < cantidad; i++) {
                edades[i] = Integer.parseInt(edadesStr[i]);
            }
        } catch (NumberFormatException e) {
            System.out.println("Error: ingresar solo números.");
            return;
        }

        int[] asientosSeleccionados = seleccionarAsientos(cantidad);
        if (asientosSeleccionados.length == 0) return;

        double precioTotal = 0;
        double precioSinDescuento = 0;
        for (int i = 0; i < cantidad; i++) {
            int asiento = asientosSeleccionados[i];
            int edad = edades[i];
            double base = obtenerPrecioBase(asiento);
            precioSinDescuento += base;
            precioTotal += calcularPrecioIndividual(asiento, edad);
        }

        double descuentoTotal = precioSinDescuento - precioTotal;
        Entrada entrada = new Entrada(cliente, edades[0], funcion, cantidad, asientosSeleccionados, false, precioTotal, descuentoTotal);

        for (int asiento : asientosSeleccionados) {
            estadoDeAsientos[asiento - 1] = 1;
        }

        entradas.add(entrada);
        System.out.println("Reserva realizada. ID: " + entrada.id);
    }

    public void comprarEntrada() {
        actualizarReservasExpiradas();
        System.out.print("Nombre del cliente: ");
        String cliente = scanner.nextLine();
        System.out.print("Nombre de la función: ");
        String funcion = scanner.nextLine();
        System.out.print("Cantidad de entradas: ");
        int cantidad = Integer.parseInt(scanner.nextLine());

        System.out.print("Ingrese las edades separadas por espacio (" + cantidad + " edades): ");
        String[] edadesStr = scanner.nextLine().split(" ");
        if (edadesStr.length != cantidad) {
            System.out.println("Cantidad de edades incorrecta.");
            return;
        }

        int[] edades = new int[cantidad];
        try {
            for (int i = 0; i < cantidad; i++) {
                edades[i] = Integer.parseInt(edadesStr[i]);
            }
        } catch (NumberFormatException e) {
            System.out.println("Error en edades.");
            return;
        }

        int[] asientosSeleccionados = seleccionarAsientos(cantidad);
        if (asientosSeleccionados.length == 0) return;

        double precioTotal = 0;
        double precioSinDescuento = 0;
        for (int i = 0; i < cantidad; i++) {
            double base = obtenerPrecioBase(asientosSeleccionados[i]);
            precioSinDescuento += base;
            precioTotal += calcularPrecioIndividual(asientosSeleccionados[i], edades[i]);
        }

        double descuentoTotal = precioSinDescuento - precioTotal;
        Entrada entrada = new Entrada(cliente, edades[0], funcion, cantidad, asientosSeleccionados, true, precioTotal, descuentoTotal);

        for (int asiento : asientosSeleccionados) {
            estadoDeAsientos[asiento - 1] = 2;
        }

        entradas.add(entrada);
        ingresosTotales += precioTotal;

        System.out.println("Compra exitosa. ID: " + entrada.id);
    }

    public void imprimirBoleta() {
        actualizarReservasExpiradas();
        System.out.print("Ingrese ID de la entrada: ");
        int id = Integer.parseInt(scanner.nextLine());

        for (Entrada e : entradas) {
            if (e.id == id) {
                e.imprimirBoleta();
                return;
            }
        }
        System.out.println("No se encontró esa entrada.");
    }

    private double obtenerPrecioBase(int asiento) {
        if (asiento <= 10) return 20000;
        if (asiento <= 20) return 15000;
        return 8000;
    }

    private double calcularPrecioIndividual(int asiento, int edad) {
        double base = obtenerPrecioBase(asiento);
        if (edad < 18) return base * 0.90;
        if (edad > 65) return base * 0.80;
        return base;
    }

    public static void mostrarIngresosTotales() {
        System.out.println("Ingresos totales: $" + ingresosTotales);
    }
}

public class Exp3_S8_Saul_Gatica {
    public static void main(String[] args) {
        SistemaTeatro sistema = new SistemaTeatro();
        Scanner scanner = new Scanner(System.in);
        int opcion;

        do {
            System.out.println("===== MENU TEATRO =====");
            System.out.println("1. Reservar entrada");
            System.out.println("2. Comprar entrada");
            System.out.println("3. Imprimir boleta");
            System.out.println("4. Mostrar ingresos totales");
            System.out.println("0. Salir");
            System.out.print("Opción: ");
            opcion



= Integer.parseInt(scanner.nextLine());
        switch (opcion) {
            case 1 -> sistema.reservarEntrada();
            case 2 -> sistema.comprarEntrada();
            case 3 -> sistema.imprimirBoleta();
            case 4 -> SistemaTeatro.mostrarIngresosTotales();
            case 0 -> System.out.println("Gracias por usar el sistema.");
            default -> System.out.println("Opción no válida.");
        }
    } while (opcion != 0);
    }
}1