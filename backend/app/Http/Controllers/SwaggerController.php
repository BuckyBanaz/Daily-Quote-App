<?php

namespace App\Http\Controllers;

use OpenApi\Annotations as OA;

/**
 * @OA\Info(
 *      version="1.0.0",
 *      title="Quote App Backend API",
 *      description="Documentation for Quote App Backend",
 *      @OA\Contact(
 *          email="admin@admin.com"
 *      )
 * )
 *
 * @OA\Server(
 *      url="http://127.0.0.1:8000",
 *      description="Local API Server"
 * )
 *
 * @OA\PathItem(
 *      path="/api/health"
 * )
 *
 * @OA\Get(
 *      path="/api/health",
 *      summary="Health Check",
 *      tags={"Utility"},
 *      @OA\Response(
 *          response=200,
 *          description="OK"
 *      )
 * )
 */
class SwaggerController extends Controller
{
    //
}
