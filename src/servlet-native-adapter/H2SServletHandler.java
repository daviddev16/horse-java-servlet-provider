package br.com.shopweb.h2s;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.server.ServletServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.HttpRequestHandler;

import java.io.IOException;
import java.io.PrintWriter;

@Component("/h2s/**")
public class H2SServletHandler implements HttpRequestHandler {

    @Override
    public void handleRequest(
        HttpServletRequest request,
        HttpServletResponse response) throws ServletException, IOException
    {
        final String bridgeName = extractBridgeName( request );
        final String prefixPath = "/h2s/" + bridgeName + "/";

        final HttpServletRequestAdapter requestAdapter =
                new HttpServletRequestAdapter( prefixPath, request );

        final RawResponseData responseData = H2SRegistry
                .getBridge( bridgeName )
                .handleRequest( requestAdapter.getRawRequestData() );

        //
        // 569 usado internamente para representar uma Exception nativa
        //
        response.setStatus( responseData.statusCode() );

        if ( responseData.statusCode() == 569 )
            throw new NativeLibraryException( responseData.body() );

        response.setContentType( responseData.contentType() );
        response.setContentLength( responseData.contentLength() );

        try ( var writer = response.getWriter() ) {
            writer.write( responseData.body() );
            writer.flush();
        } catch (Exception e) {
            throw new RuntimeException( e );
        }
    }

    private String extractBridgeName(HttpServletRequest request) {
        String path = request.getServletPath().replaceFirst( "/h2s/", "" );
        return path.substring( 0, path.indexOf( "/" ) );
    }

}
