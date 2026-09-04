package main;

import io.h2s.H2SRegistry;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

import java.nio.file.Path;

@SpringBootApplication
@ComponentScan(basePackages = "io.h2s")
public class HorseConnectSpringApplication {

	public static void main(String[] args) {
        H2SRegistry.register( "horse-connect", Path.of( "C:\\temp\\HorseConnectAPI.dll" ) );

		SpringApplication.run(HorseConnectSpringApplication.class, args);
	}

}
