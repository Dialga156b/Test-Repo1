<# 
    Simple TCP Receiver (Dispatcher) Script in PowerShell.
    This script listens on a specified port (default 12345) for incoming TCP connections.
    When a client connects, it reads messages line by line and prints them to the console.
    
    Usage:
      1. Save this script as "receiver.ps1"
      2. Open PowerShell and navigate to the script's directory.
      3. Run the script: .\receiver.ps1
      (You can optionally specify a different port: .\receiver.ps1 -Port 12345)
#>

param(
    [int]$Port = 12345
)

# Create a TcpListener on all network interfaces
$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, $Port)
$listener.Start()
Write-Host "Receiver listening on port $Port..."

try {
    # Accept a client connection (blocking call)
    $client = $listener.AcceptTcpClient()
    Write-Host "Client connected from $($client.Client.RemoteEndPoint)."
    
    $stream = $client.GetStream()
    $reader = [System.IO.StreamReader]::new($stream)
    
    Write-Host "Waiting for messages. Press Ctrl+C to stop..."
    while ($client.Connected) {
        # Read a line (assumes the client sends messages ending with a newline)
        $line = $reader.ReadLine()
        if ($line -eq $null) { break }
        Write-Host "Received: $line"
    }
}
catch {
    Write-Error "An error occurred: $_"
}
finally {
    if ($reader) { $reader.Close() }
    if ($client) { $client.Close() }
    $listener.Stop()
    Write-Host "Listener stopped."
}
