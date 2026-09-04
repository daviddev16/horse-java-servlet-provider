package io.h2s;

public interface NativeBridge {

    void initialize();

    RawResponseData handleRequest(final RawRequestData requestData);

}
