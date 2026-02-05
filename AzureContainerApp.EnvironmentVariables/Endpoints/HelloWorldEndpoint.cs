namespace AzureContainerApp.EnvironmentVariables.Endpoints;

public static class HelloWorldEndpoint
{
    public static IEndpointRouteBuilder MapHelloWorldEndpoint(this IEndpointRouteBuilder app)
    {
        app.MapGet("/", () => "Hello World!")
            .WithName("GetHelloWorld");

        return app;
    }
}