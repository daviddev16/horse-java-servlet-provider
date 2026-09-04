package io.h2s;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

public class HttpServletRequestAdapter {

    private final String body;
    private final String contentType;
    private final Integer contentLength;
    private final String pathInfo;
    private final String methodType;
    private final List<String> queries;
    private final List<String> headers;
    private final String protocolVersion;
    private final Integer localPort;
    private final String localHost;
    private final String remoteAddress;
    private final Integer remotePort;
    private final String fullPath;
    private final List<String> cookies;
    private final String queryString;

    public HttpServletRequestAdapter(
        final String prefixPath,
        final HttpServletRequest servletRequest)
    {
        this.body = extractBody( servletRequest );
        this.contentType = servletRequest.getContentType();
        this.contentLength = servletRequest.getContentLength();
        this.methodType = servletRequest.getMethod();
        this.queries = extractQueries( servletRequest );
        this.headers = extractHeaders( servletRequest );
        this.protocolVersion = servletRequest.getProtocol();
        this.localPort = servletRequest.getLocalPort();
        this.localHost = servletRequest.getLocalName();
        this.remoteAddress = servletRequest.getRemoteAddr();
        this.remotePort = servletRequest.getRemotePort();
        this.fullPath = servletRequest.getRequestURI().replace( prefixPath, "" );
        this.pathInfo = this.fullPath;
        this.cookies = extractCookies( servletRequest );
        this.queryString = servletRequest.getQueryString();
    }

    private String extractBody(HttpServletRequest request) {
        try ( BufferedReader bufferedReader = request.getReader() ) {
            if ( bufferedReader == null )
                return null;

            return bufferedReader
                .lines()
                .collect( Collectors.joining( System.lineSeparator() ) );
        } catch ( IOException | IllegalStateException e ) {
            return null;
        }
    }

    private List<String> extractQueries(HttpServletRequest request) {
        String queryString = request.getQueryString();

        if ( queryString == null || queryString.isEmpty() )
            return Collections.emptyList();

        return new ArrayList<>( Arrays.asList( queryString.split( "&" ) ) );
    }

    private List<String> extractHeaders(HttpServletRequest request) {
        Enumeration<String> headerNames = request.getHeaderNames();

        if ( headerNames == null )
            return Collections.emptyList();

        List<String> headerList = new ArrayList<>();

        while ( headerNames.hasMoreElements() ) {
            String name = headerNames.nextElement();
            Enumeration<String> values = request.getHeaders( name );
            while ( values.hasMoreElements() )
                headerList.add( name + "=" + values.nextElement() );
        }

        return headerList;
    }

    private List<String> extractCookies(HttpServletRequest request) {
        Cookie[] requestCookies = request.getCookies();

        if ( requestCookies == null || requestCookies.length == 0 )
            return Collections.emptyList();

        List<String> cookieList = new ArrayList<>();

        for (Cookie cookie : requestCookies)
            cookieList.add(cookie.getName() + "=" + cookie.getValue());

        return cookieList;
    }

    public RawRequestData getRawRequestData() {
        return new RawRequestData(
            this.body,
            this.contentType,
            this.contentLength,
            this.pathInfo,
            this.methodType,
            this.queries,
            this.headers,
            this.protocolVersion,
            this.localPort,
            this.localHost,
            this.remoteAddress,
            this.remotePort,
            this.fullPath,
            this.cookies,
            this.queryString
        );
    }
}
