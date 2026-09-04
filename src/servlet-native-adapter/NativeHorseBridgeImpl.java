package br.com.shopweb.h2s;

import tools.jackson.databind.ObjectMapper;

import java.lang.foreign.Arena;
import java.lang.foreign.MemorySegment;

public class NativeHorseBridgeImpl implements NativeBridge {

    private static final ObjectMapper MAPPER = new ObjectMapper();

    private boolean loaded;
    private final NativeLibrary library;

    public NativeHorseBridgeImpl(NativeLibrary library) {
        this.library = library;
    }

    private String handleRequestImpl(final String requestStr) {
        try ( Arena arena = Arena.ofConfined() ) {
            MemorySegment requestStrMS = arena.allocateFrom( requestStr );

            MemorySegment resultPtr = (MemorySegment)
                library.getHandleRequestMHandle().invoke( requestStrMS );

            if ( resultPtr.equals( MemorySegment.NULL ) )
                throw new NativeLibraryException( "Failed to handle native response." );

            try {
                return resultPtr.reinterpret( Long.MAX_VALUE ).getString( 0 );
            } finally {
                library.getReclaimMemoryMHandle().invoke( resultPtr );
            }
        } catch ( Throwable e ) {
            if ( e instanceof NativeLibraryException )
                throw (NativeLibraryException) e;

            throw new NativeLibraryException( "Failed to handle native request.", e );
        }
    }

    @Override
    public boolean loaded() {
        return loaded;
    }

    @Override
    public void initialize() {
        try {
            library.getInitializeMHandle().invoke();
            loaded = true;
        } catch (Throwable e) {
            throw new NativeLibraryException( "Failed to initialize bridge", e );
        }
    }

    @Override
    public RawResponseData handleRequest(final RawRequestData requestData) {
        final String requestStr = MAPPER.writeValueAsString( requestData );
        final String responseStr = handleRequestImpl( requestStr );
        return MAPPER.readValue( responseStr, RawResponseData.class );
    }
}
