package br.com.shopweb.h2s;

public interface NativeBridge {

    boolean loaded();

    void initialize();

    RawResponseData handleRequest(final RawRequestData requestData);

}
