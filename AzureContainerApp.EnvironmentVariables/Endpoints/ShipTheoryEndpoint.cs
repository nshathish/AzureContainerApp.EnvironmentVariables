namespace AzureContainerApp.EnvironmentVariables.Endpoints;

public static class ShipTheoryEndpoint
{
    public static IEndpointRouteBuilder MapShipTheoryEndpoint(this IEndpointRouteBuilder app)
    {
        app.MapGet("/api/ship-theory", (IConfiguration configuration) =>
            {
                var shipTheoryUrl = configuration.GetValue<string>("ShipTheoryApiUrl");
                if (string.IsNullOrEmpty(shipTheoryUrl))
                {
                    return Results.BadRequest("ShipTheoryApiUrl is not configured.");
                }

                return Results.Ok(new { Url = shipTheoryUrl });
            })
            .WithName("GetShipTheoryUrl");

        return app;
    }
}