package br.com.shopweb.h2s;

import java.nio.file.Path;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;

public class H2SRegistry {

    private static final String DEFAULT_LIBRARY_NAME = "_default";
    private static final Map<String, NativeBridge> bridges = new ConcurrentHashMap<>();

    public static void register(String name, Path libraryPath) {
        Objects.requireNonNull( name, "name is null" );
        Objects.requireNonNull( libraryPath, "libraryPath is null" );

        if ( bridges.containsKey( name ) )
            throw new NativeLibraryException( " Already loaded : " + libraryPath );

        try {
            NativeLibrary loadedLibrary = new NativeLibraryBinderImpl( libraryPath );
            bridges.put( name, new NativeHorseBridgeImpl( loadedLibrary ) );
        } catch ( Throwable t ) {
            throw new NativeLibraryException( "Failed to load native library : " + libraryPath, t );
        }
    }

    public static NativeBridge getBridge(String name) {
        final NativeBridge bridge = bridges.get( name );
        if ( bridge == null )
            throw new NativeLibraryException( "No native library registered with name : " + name );
        if ( !bridge.loaded() ) {
            synchronized ( bridge ) {
                if ( !bridge.loaded() )
                    bridge.initialize();
            }
        }
        return bridge;
    }

}
