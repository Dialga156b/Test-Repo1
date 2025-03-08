<# 
    Simple TCP Sender (Client) Script in PowerShell.
    This script connects to a TCP server at a given IP address and port (default 12345).
    It then allows the user to type messages and sends them to the server.
    
    Usage:
      1. Save this script as "sender.ps1"
      2. Open PowerShell and navigate to the script's directory.
      3. Run the script: .\sender.ps1 -ServerIP <Receiver_IP_Address> [-Port 12345]
      (If the port is not specified, it defaults to 12345.)
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ServerIP,
    [int]$Port = 12345
)

try {
    # Create a TcpClient and connect to the server
    $client = New-Object System.Net.Sockets.TcpClient
    $client.Connect($ServerIP, $Port)
    Write-Host "Connected to $ServerIP on port $Port."

    # Get the network stream
    $stream = $client.GetStream()

    # Create a StreamWriter to write to the stream, and enable automatic flush
    $writer = New-Object System.IO.StreamWriter($stream)
    $writer.AutoFlush = $true

    Write-Host "Enter messages to send to the server. Press Ctrl+C to exit."
    
    while ($true) {
        $message = Read-Host "Message"
        if (![string]::IsNullOrEmpty($message)) {
            $writer.WriteLine($message)
            Write-Host "Message sent."
        }
    }
}
catch {
    Write-Error "An error occurred: $_"
}
finally {
    if ($writer) { $writer.Close() }
    if ($stream) { $stream.Close() }
    if ($client) { $client.Close() }
    Write-Host "Connection closed."
}
