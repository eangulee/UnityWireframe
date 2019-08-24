using System.Collections;
using System.Collections.Generic;
using Unity.Collections;
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif
[ExecuteInEditMode]
public class MeshWireframe : MonoBehaviour
{
    public Color lineColor = Color.white;
    public Material lineMat;
    [ReadOnly]
    [Tooltip("根据当前模型自动获取mesh")]
    public List<Mesh> meshs;
    [ReadOnly]
    [Tooltip("根据当前模型自动算计line")]
    public List<Vector3> lines;

    private void OnRenderObject()
    {
        lineMat.SetColor("_LineColor", lineColor);
        lineMat.SetPass(0);
        GL.PushMatrix();

        //转换到世界坐标
        GL.MultMatrix(transform.localToWorldMatrix);
        GL.Begin(GL.LINES);
        for (int i = 0; i < lines.Count / 3; i++)
        {
            GL.Vertex(lines[i * 3]);
            GL.Vertex(lines[i * 3 + 1]);
            GL.Vertex(lines[i * 3 + 1]);
            GL.Vertex(lines[i * 3 + 2]);
            GL.Vertex(lines[i * 3 + 2]);
            GL.Vertex(lines[i * 3]);
        }
        GL.End();
        GL.PopMatrix();
    }

    private void GenerateLines()
    {
        if (lines != null)
            lines.Clear();
        else
            lines = new List<Vector3>();
        foreach (var mesh in meshs)
        {
            var vertices = mesh.vertices;
            var triangles = mesh.triangles;
            for (int i = 0; i < triangles.Length / 3; i++)
            {
                lines.Add(vertices[triangles[i * 3]]);
                lines.Add(vertices[triangles[i * 3 + 1]]);
                lines.Add(vertices[triangles[i * 3 + 2]]);
            }
        }
    }

    [ContextMenu("根据MeshFilter组件生成Line数据")]
    private void GetMeshesData()
    {
#if UNITY_EDITOR
        GameObject o = UnityEditor.Selection.activeGameObject;
        if (o == null)
            return;
        if (meshs != null)
            meshs.Clear();
        else
            meshs = new List<Mesh>();
        MeshFilter[] meshFilters = o.GetComponentsInChildren<MeshFilter>(true);
        if (meshFilters != null && meshFilters.Length > 0)
        {
            foreach (var mf in meshFilters)
            {
                meshs.Add(mf.sharedMesh);
            }
            GenerateLines();
        }
        else
        {
            Debug.LogError("选中物体及子物体没有MeshFilter组件，请添加");
        }

        SkinnedMeshRenderer[] skinnedMeshRenderers = o.GetComponentsInChildren<SkinnedMeshRenderer>(true);
        if (skinnedMeshRenderers != null && skinnedMeshRenderers.Length > 0)
        {
            foreach (var sr in skinnedMeshRenderers)
            {
                meshs.Add(sr.sharedMesh);
            }
            GenerateLines();
        }
        else
        {
            Debug.LogError("选中物体及子物体没有SkinnedMeshRenderer组件，请添加");
        }
#endif
    }
}
