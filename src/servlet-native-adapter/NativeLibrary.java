package br.com.shopweb.h2s;

import java.lang.invoke.MethodHandle;

public interface NativeLibrary {

    MethodHandle getHandleRequestMHandle();

    MethodHandle getReclaimMemoryMHandle();

    MethodHandle getInitializeMHandle();

}
