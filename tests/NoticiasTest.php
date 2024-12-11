<?php

use PHPUnit\Framework\TestCase;

require_once('./src/index.php');

class NoticiasTest extends TestCase {
    public function testNoticia() {
        $noticia = new Noticia("Título de prueba", "Contenido de prueba", "2024-01-01");

        $this->assertEquals("Título de prueba", $noticia->getTitulo());
        $this->assertEquals("Contenido de prueba", $noticia->getContenido());
        $this->assertEquals("2024-01-01", $noticia->getFecha());
    }
}
