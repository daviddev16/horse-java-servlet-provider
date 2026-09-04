package io.h2s;

import java.lang.foreign.*;
import java.lang.invoke.MethodHandle;
import java.nio.file.Path;

public class NativeLibraryBinderImpl implements NativeLibrary {

    private final Arena arena;
    private final MethodHandle initializeMH;
    private final MethodHandle handleRequestMH;
    private final MethodHandle reclaimMemoryMH;

    public NativeLibraryBinderImpl(final Path libraryPath) {
        arena = Arena.ofShared();
        Linker linker = Linker.nativeLinker();

        SymbolLookup symbolLookup = SymbolLookup.libraryLookup(
            libraryPath, arena );

        initializeMH = linker.downcallHandle(
            symbolLookup.find( "FF_Initialize" ).orElseThrow(),
            FunctionDescriptor.of( ValueLayout.JAVA_INT )
        );

        handleRequestMH = linker.downcallHandle(
            symbolLookup.find( "FF_HandleRequest" ).orElseThrow(),
            FunctionDescriptor.of(
                ValueLayout.ADDRESS,   /* PUTF8Char */
                ValueLayout.ADDRESS    /* PUTF8Char */
            )
        );

        reclaimMemoryMH = linker.downcallHandle(
            symbolLookup.find( "FF_ReclaimMemory" ).orElseThrow(),
            FunctionDescriptor.ofVoid( ValueLayout.ADDRESS /* PUTF8Char */ ) );

        Runtime.getRuntime().addShutdownHook( new Thread( this::close ) );
    }

    @Override
    public MethodHandle getHandleRequestMHandle() {
        return handleRequestMH;
    }

    @Override
    public MethodHandle getReclaimMemoryMHandle() {
        return reclaimMemoryMH;
    }

    @Override
    public MethodHandle getInitializeMHandle() {
        return initializeMH;
    }

    public void close() {
        if ( arena.scope().isAlive() )
            arena.close();
    }
}
