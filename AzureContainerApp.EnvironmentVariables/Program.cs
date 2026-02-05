using AzureContainerApp.EnvironmentVariables.Endpoints;
using Scalar.AspNetCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenApi();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.MapScalarApiReference(opts =>
    {
        opts.DarkMode = false;
    });
}

app.UseHttpsRedirection();

app.MapHelloWorldEndpoint();
app.MapWeatherForecastEndpoint();
app.MapShipTheoryEndpoint();

app.Run();